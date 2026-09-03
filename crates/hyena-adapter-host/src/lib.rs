#![forbid(unsafe_code)]

use std::{
    collections::{BTreeMap, BTreeSet},
    ffi::{OsStr, OsString},
    io::Read,
    path::Path,
    process::{Child, ChildStdin, Command, Stdio},
    sync::{Arc, Mutex, mpsc},
    thread,
    time::{Duration, Instant},
};

use hyena_engine::{
    Completeness, DeadCodeCompleteness, ModelError, RetentionEdge as EngineEdge, RetentionGraph,
    SourceSpan as EngineSpan, Symbol as EngineSymbol, SymbolKey as EngineKey, SymbolStability,
};
use hyena_protocol::{
    DEFAULT_MAX_FRAME_BYTES, FrameError, PROTOCOL_MAJOR, PROTOCOL_MINOR,
    adapter::{self, envelope},
    read_envelope, write_envelope,
};
use thiserror::Error;

pub const SOURCE_DISCOVERY_DIMENSION: &str = "hyena.dead_code.source_discovery";
pub const SEMANTIC_RESOLUTION_DIMENSION: &str = "hyena.dead_code.semantic_resolution";
pub const ROOTS_DIMENSION: &str = "hyena.dead_code.roots";
pub const RETENTION_EDGES_DIMENSION: &str = "hyena.dead_code.retention_edges";
pub const DYNAMIC_BEHAVIOR_DIMENSION: &str = "hyena.dead_code.dynamic_behavior";

const REQUIRED_CAPABILITIES: [&str; 4] = [
    "hyena.artifacts",
    "hyena.semantic.symbols",
    "hyena.semantic.retention",
    "hyena.semantic.roots",
];

#[derive(Clone, Copy, Debug)]
pub struct HostLimits {
    pub max_frame_bytes: usize,
    pub max_facts: usize,
    pub max_stderr_bytes: usize,
    pub request_timeout: Duration,
}

impl Default for HostLimits {
    fn default() -> Self {
        Self {
            max_frame_bytes: DEFAULT_MAX_FRAME_BYTES,
            max_facts: 1_000_000,
            max_stderr_bytes: 64 * 1024,
            request_timeout: Duration::from_secs(60),
        }
    }
}

#[derive(Clone, Debug)]
pub struct AdapterInfo {
    pub name: String,
    pub version: String,
    pub capabilities: BTreeMap<String, u32>,
}

#[derive(Debug)]
pub struct AdapterClient {
    child: Child,
    input: Option<ChildStdin>,
    messages: mpsc::Receiver<Result<adapter::Envelope, String>>,
    stderr: Arc<Mutex<Vec<u8>>>,
    limits: HostLimits,
    next_request_id: u64,
    info: AdapterInfo,
}

impl AdapterClient {
    pub fn spawn(
        program: &OsStr,
        args: &[OsString],
        limits: HostLimits,
    ) -> Result<Self, HostError> {
        if limits.max_frame_bytes == 0 || limits.max_frame_bytes > u32::MAX as usize {
            return Err(HostError::InvalidLimits("max_frame_bytes must fit a non-zero u32"));
        }

        let mut child = Command::new(program)
            .args(args)
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .map_err(|source| HostError::Spawn {
                program: program.to_string_lossy().into_owned(),
                source,
            })?;
        let input = child.stdin.take().ok_or(HostError::MissingPipe("stdin"))?;
        let mut output = child.stdout.take().ok_or(HostError::MissingPipe("stdout"))?;
        let mut child_stderr = child.stderr.take().ok_or(HostError::MissingPipe("stderr"))?;

        let (sender, messages) = mpsc::channel();
        let max_frame_bytes = limits.max_frame_bytes;
        thread::spawn(move || {
            loop {
                match read_envelope(&mut output, max_frame_bytes) {
                    Ok(Some(message)) => {
                        if sender.send(Ok(message)).is_err() {
                            break;
                        }
                    }
                    Ok(None) => break,
                    Err(error) => {
                        let _ = sender.send(Err(error.to_string()));
                        break;
                    }
                }
            }
        });

        let stderr = Arc::new(Mutex::new(Vec::new()));
        let stderr_writer = Arc::clone(&stderr);
        let max_stderr_bytes = limits.max_stderr_bytes;
        thread::spawn(move || {
            let mut buffer = [0_u8; 4096];
            while let Ok(read) = child_stderr.read(&mut buffer) {
                if read == 0 {
                    break;
                }
                if let Ok(mut captured) = stderr_writer.lock() {
                    let remaining = max_stderr_bytes.saturating_sub(captured.len());
                    captured.extend_from_slice(&buffer[..read.min(remaining)]);
                }
            }
        });

        let mut client = Self {
            child,
            input: Some(input),
            messages,
            stderr,
            limits,
            next_request_id: 1,
            info: AdapterInfo {
                name: String::new(),
                version: String::new(),
                capabilities: BTreeMap::new(),
            },
        };
        client.negotiate()?;
        Ok(client)
    }

    pub fn info(&self) -> &AdapterInfo {
        &self.info
    }

    pub fn analyze(
        &mut self,
        workspace_root: &Path,
        target: &str,
    ) -> Result<AdapterAnalysis, HostError> {
        let request_id = self.next_request_id();
        let request = adapter::Envelope {
            request_id,
            message: Some(envelope::Message::AnalyzeRequest(adapter::AnalyzeRequest {
                workspace_root: workspace_root.to_string_lossy().into_owned(),
                target: target.to_owned(),
                configuration_digest: Vec::new(),
                variant_id: "default".to_owned(),
            })),
        };
        self.send(&request)?;

        let mut analysis = AdapterAnalysis::default();
        let mut expected_sequence = 0_u64;
        let mut fact_count = 0_usize;
        let started = Instant::now();
        loop {
            let remaining = self.limits.request_timeout.saturating_sub(started.elapsed());
            let response = self.receive_with_timeout("analysis", remaining)?;
            if response.request_id != request_id {
                self.terminate();
                return Err(HostError::UnexpectedResponse(format!(
                    "expected request_id {request_id}, received {}",
                    response.request_id
                )));
            }
            match response.message {
                Some(envelope::Message::FactBatch(batch)) => {
                    if batch.sequence != expected_sequence {
                        self.terminate();
                        return Err(HostError::UnexpectedResponse(format!(
                            "expected fact batch {expected_sequence}, received {}",
                            batch.sequence
                        )));
                    }
                    expected_sequence += 1;
                    let batch_facts = batch
                        .artifacts
                        .len()
                        .saturating_add(batch.symbols.len())
                        .saturating_add(batch.retention_edges.len())
                        .saturating_add(batch.roots.len())
                        .saturating_add(batch.diagnostics.len());
                    fact_count = fact_count.saturating_add(batch_facts);
                    if fact_count > self.limits.max_facts {
                        self.terminate();
                        return Err(HostError::FactLimit {
                            facts: fact_count,
                            limit: self.limits.max_facts,
                        });
                    }
                    analysis.artifacts.extend(batch.artifacts);
                    analysis.symbols.extend(batch.symbols);
                    analysis.retention_edges.extend(batch.retention_edges);
                    analysis.roots.extend(batch.roots);
                    analysis.diagnostics.extend(batch.diagnostics);
                }
                Some(envelope::Message::Complete(complete)) => {
                    analysis.complete = Some(complete);
                    analysis.validate()?;
                    return Ok(analysis);
                }
                Some(envelope::Message::Error(error)) => {
                    return Err(HostError::Adapter {
                        code: error.code,
                        message: error.message,
                        retryable: error.retryable,
                    });
                }
                _ => {
                    self.terminate();
                    return Err(HostError::UnexpectedResponse(
                        "adapter returned a non-analysis message".to_owned(),
                    ));
                }
            }
        }
    }

    fn negotiate(&mut self) -> Result<(), HostError> {
        let request_id = self.next_request_id();
        self.send(&adapter::Envelope {
            request_id,
            message: Some(envelope::Message::Hello(adapter::Hello {
                engine_name: "hyena".to_owned(),
                engine_version: env!("CARGO_PKG_VERSION").to_owned(),
                supported_versions: vec![adapter::ProtocolVersion {
                    major: PROTOCOL_MAJOR,
                    minor: PROTOCOL_MINOR,
                }],
                max_frame_bytes: self.limits.max_frame_bytes as u32,
            })),
        })?;
        let response = self.receive("handshake")?;
        if response.request_id != request_id {
            self.terminate();
            return Err(HostError::UnexpectedResponse(
                "adapter handshake used the wrong request_id".to_owned(),
            ));
        }
        let ready = match response.message {
            Some(envelope::Message::Ready(ready)) => ready,
            Some(envelope::Message::Error(error)) => {
                return Err(HostError::Adapter {
                    code: error.code,
                    message: error.message,
                    retryable: error.retryable,
                });
            }
            _ => {
                self.terminate();
                return Err(HostError::UnexpectedResponse(
                    "adapter did not return Ready during handshake".to_owned(),
                ));
            }
        };
        let selected = ready.selected_version.ok_or_else(|| {
            HostError::UnexpectedResponse("Ready omitted selected_version".to_owned())
        })?;
        if selected.major != PROTOCOL_MAJOR || selected.minor != PROTOCOL_MINOR {
            self.terminate();
            return Err(HostError::UnexpectedResponse(format!(
                "adapter selected unsupported protocol {}.{}",
                selected.major, selected.minor
            )));
        }
        let adapter = ready.adapter.ok_or_else(|| {
            HostError::UnexpectedResponse("Ready omitted adapter info".to_owned())
        })?;
        if adapter.name.is_empty() || adapter.version.is_empty() {
            return Err(HostError::UnexpectedResponse(
                "adapter name and version must not be empty".to_owned(),
            ));
        }
        let capabilities = ready
            .capabilities
            .into_iter()
            .map(|capability| (capability.id, capability.version))
            .collect::<BTreeMap<_, _>>();
        for required in REQUIRED_CAPABILITIES {
            if capabilities.get(required).copied() != Some(1) {
                return Err(HostError::MissingCapability(required));
            }
        }
        self.info = AdapterInfo { name: adapter.name, version: adapter.version, capabilities };
        Ok(())
    }

    fn next_request_id(&mut self) -> u64 {
        let request_id = self.next_request_id;
        self.next_request_id = self.next_request_id.saturating_add(1);
        request_id
    }

    fn send(&mut self, envelope: &adapter::Envelope) -> Result<(), HostError> {
        if self.input.is_none() {
            return Err(HostError::Terminated { stderr: self.stderr_snapshot() });
        }
        let input = self.input.as_mut().expect("adapter input was checked immediately above");
        write_envelope(input, envelope, self.limits.max_frame_bytes)?;
        Ok(())
    }

    fn receive(&mut self, operation: &'static str) -> Result<adapter::Envelope, HostError> {
        self.receive_with_timeout(operation, self.limits.request_timeout)
    }

    fn receive_with_timeout(
        &mut self,
        operation: &'static str,
        timeout: Duration,
    ) -> Result<adapter::Envelope, HostError> {
        match self.messages.recv_timeout(timeout) {
            Ok(Ok(message)) => Ok(message),
            Ok(Err(message)) => {
                self.terminate();
                Err(HostError::ProtocolReader(message))
            }
            Err(mpsc::RecvTimeoutError::Timeout) => {
                self.terminate();
                Err(HostError::Timeout { operation, stderr: self.stderr_snapshot() })
            }
            Err(mpsc::RecvTimeoutError::Disconnected) => {
                self.terminate();
                Err(HostError::Terminated { stderr: self.stderr_snapshot() })
            }
        }
    }

    fn stderr_snapshot(&self) -> String {
        self.stderr
            .lock()
            .map(|bytes| String::from_utf8_lossy(&bytes).into_owned())
            .unwrap_or_else(|_| "<adapter stderr unavailable>".to_owned())
    }

    fn terminate(&mut self) {
        self.input.take();
        if self.child.try_wait().ok().flatten().is_none() {
            let _ = self.child.kill();
            let _ = self.child.wait();
        }
    }
}

impl Drop for AdapterClient {
    fn drop(&mut self) {
        self.terminate();
    }
}

#[derive(Debug, Default)]
pub struct AdapterAnalysis {
    pub artifacts: Vec<adapter::Artifact>,
    pub symbols: Vec<adapter::Symbol>,
    pub retention_edges: Vec<adapter::RetentionEdge>,
    pub roots: Vec<adapter::Root>,
    pub diagnostics: Vec<adapter::Diagnostic>,
    pub complete: Option<adapter::Complete>,
}

impl AdapterAnalysis {
    pub fn retention_graph(&self) -> Result<RetentionGraph, HostError> {
        self.validate()?;
        let symbols = self
            .symbols
            .iter()
            .map(|symbol| {
                let key = engine_key(
                    symbol.key.as_ref().ok_or(HostError::InvalidFact("symbol omitted key"))?,
                )?;
                Ok(EngineSymbol::new(key, &symbol.display_name)?)
            })
            .collect::<Result<Vec<_>, HostError>>()?;
        let roots = self
            .roots
            .iter()
            .map(|root| {
                engine_key(
                    root.symbol.as_ref().ok_or(HostError::InvalidFact("root omitted symbol"))?,
                )
            })
            .collect::<Result<Vec<_>, HostError>>()?;
        let edges = self
            .retention_edges
            .iter()
            .map(|edge| {
                let source = engine_key(
                    edge.source.as_ref().ok_or(HostError::InvalidFact("edge omitted source"))?,
                )?;
                let target = engine_key(
                    edge.target.as_ref().ok_or(HostError::InvalidFact("edge omitted target"))?,
                )?;
                EngineEdge::new(source, target, edge_reason(edge.kind)).map_err(HostError::from)
            })
            .collect::<Result<Vec<_>, HostError>>()?;
        Ok(RetentionGraph::new(symbols, roots, edges)?)
    }

    pub fn dead_code_completeness(&self) -> Result<DeadCodeCompleteness, HostError> {
        self.validate()?;
        let dimensions = self
            .complete
            .as_ref()
            .ok_or(HostError::InvalidFact("analysis omitted Complete"))?
            .dimensions
            .iter()
            .map(|dimension| {
                completeness(dimension.status)
                    .map(|status| (dimension.capability_id.as_str(), status))
            })
            .collect::<Result<BTreeMap<_, _>, _>>()?;
        let get = |name| dimensions.get(name).copied().unwrap_or(Completeness::Unsupported);
        Ok(DeadCodeCompleteness {
            source_discovery: get(SOURCE_DISCOVERY_DIMENSION),
            semantic_resolution: get(SEMANTIC_RESOLUTION_DIMENSION),
            roots: get(ROOTS_DIMENSION),
            retention_edges: get(RETENTION_EDGES_DIMENSION),
            dynamic_behavior: get(DYNAMIC_BEHAVIOR_DIMENSION),
        })
    }

    pub fn validate(&self) -> Result<(), HostError> {
        let complete =
            self.complete.as_ref().ok_or(HostError::InvalidFact("analysis omitted Complete"))?;
        let status = adapter::CompletionStatus::try_from(complete.status)
            .map_err(|_| HostError::InvalidFact("Complete has unknown status"))?;
        if matches!(
            status,
            adapter::CompletionStatus::Unspecified
                | adapter::CompletionStatus::Cancelled
                | adapter::CompletionStatus::Failed
        ) {
            return Err(HostError::InvalidFact(
                "analysis did not complete successfully or partially",
            ));
        }

        let mut artifacts = BTreeMap::new();
        for artifact in &self.artifacts {
            validate_artifact_id(&artifact.id)?;
            if artifact.language.is_empty() {
                return Err(HostError::InvalidFact("artifact language is empty"));
            }
            let digest = artifact
                .content_digest
                .as_ref()
                .ok_or(HostError::InvalidFact("artifact omitted content digest"))?;
            if digest.algorithm.is_empty() || digest.value.is_empty() {
                return Err(HostError::InvalidFact("artifact digest is incomplete"));
            }
            if adapter::SourceEncoding::try_from(artifact.source_encoding).is_err()
                || artifact.source_encoding == adapter::SourceEncoding::Unspecified as i32
            {
                return Err(HostError::InvalidFact("artifact has unknown source encoding"));
            }
            if adapter::ArtifactOrigin::try_from(artifact.origin).is_err()
                || artifact.origin == adapter::ArtifactOrigin::Unspecified as i32
            {
                return Err(HostError::InvalidFact("artifact has unknown origin"));
            }
            if artifacts.insert(artifact.id.as_str(), artifact.byte_length).is_some() {
                return Err(HostError::InvalidFact("duplicate artifact id"));
            }
        }

        let mut symbol_keys = BTreeSet::new();
        for symbol in &self.symbols {
            let key = symbol.key.as_ref().ok_or(HostError::InvalidFact("symbol omitted key"))?;
            let engine_key = engine_key(key)?;
            if !symbol_keys.insert(engine_key) {
                return Err(HostError::InvalidFact("duplicate symbol key"));
            }
            if symbol.display_name.is_empty() || symbol.qualified_name.is_empty() {
                return Err(HostError::InvalidFact("symbol name is empty"));
            }
            if adapter::SymbolKind::try_from(symbol.kind).is_err()
                || symbol.kind == adapter::SymbolKind::Unspecified as i32
            {
                return Err(HostError::InvalidFact("symbol kind is unknown"));
            }
            if adapter::Visibility::try_from(symbol.visibility).is_err()
                || symbol.visibility == adapter::Visibility::Unspecified as i32
            {
                return Err(HostError::InvalidFact("symbol visibility is unknown"));
            }
            if adapter::ExportStatus::try_from(symbol.export_status).is_err() {
                return Err(HostError::InvalidFact("symbol export status is unknown"));
            }
            validate_span(symbol.declaration.as_ref(), &artifacts)?;
        }
        for edge in &self.retention_edges {
            let source = engine_key(
                edge.source.as_ref().ok_or(HostError::InvalidFact("edge omitted source"))?,
            )?;
            let target = engine_key(
                edge.target.as_ref().ok_or(HostError::InvalidFact("edge omitted target"))?,
            )?;
            if !symbol_keys.contains(&source) || !symbol_keys.contains(&target) {
                return Err(HostError::InvalidFact("edge references an unknown symbol"));
            }
            if adapter::RetentionEdgeKind::try_from(edge.kind).is_err()
                || edge.kind == adapter::RetentionEdgeKind::Unspecified as i32
            {
                return Err(HostError::InvalidFact("edge kind is unknown"));
            }
            validate_span(edge.evidence.as_ref(), &artifacts)?;
        }
        for root in &self.roots {
            let symbol = engine_key(
                root.symbol.as_ref().ok_or(HostError::InvalidFact("root omitted symbol"))?,
            )?;
            if !symbol_keys.contains(&symbol) {
                return Err(HostError::InvalidFact("root references an unknown symbol"));
            }
            if adapter::RootKind::try_from(root.kind).is_err()
                || root.kind == adapter::RootKind::Unspecified as i32
            {
                return Err(HostError::InvalidFact("root kind is unknown"));
            }
            if root.reason_code.is_empty() {
                return Err(HostError::InvalidFact("root reason code is empty"));
            }
            validate_span(root.evidence.as_ref(), &artifacts)?;
        }
        for diagnostic in &self.diagnostics {
            if diagnostic.code.is_empty() || diagnostic.message.is_empty() {
                return Err(HostError::InvalidFact("diagnostic code or message is empty"));
            }
            if adapter::DiagnosticSeverity::try_from(diagnostic.severity).is_err()
                || diagnostic.severity == adapter::DiagnosticSeverity::Unspecified as i32
            {
                return Err(HostError::InvalidFact("diagnostic severity is unknown"));
            }
            if let Some(span) = diagnostic.span.as_ref() {
                validate_span(Some(span), &artifacts)?;
            }
        }
        let mut dimension_ids = BTreeSet::new();
        for dimension in &complete.dimensions {
            if dimension.capability_id.is_empty() {
                return Err(HostError::InvalidFact("completeness dimension has no id"));
            }
            if !dimension_ids.insert(dimension.capability_id.as_str()) {
                return Err(HostError::InvalidFact("duplicate completeness dimension"));
            }
            let status = completeness(dimension.status)?;
            if status != Completeness::Complete && dimension.reason_code.is_empty() {
                return Err(HostError::InvalidFact("incomplete dimension omitted its reason code"));
            }
        }
        Ok(())
    }
}

fn validate_artifact_id(id: &str) -> Result<(), HostError> {
    if id.is_empty()
        || id.starts_with('/')
        || id.contains('\\')
        || id.split('/').any(|segment| segment.is_empty() || segment == "." || segment == "..")
    {
        return Err(HostError::InvalidArtifactId(id.to_owned()));
    }
    Ok(())
}

fn validate_span(
    span: Option<&adapter::SourceSpan>,
    artifacts: &BTreeMap<&str, u64>,
) -> Result<(), HostError> {
    let span = span.ok_or(HostError::InvalidFact("fact omitted source span"))?;
    let artifact_bytes = artifacts
        .get(span.artifact_id.as_str())
        .copied()
        .ok_or_else(|| HostError::UnknownArtifact(span.artifact_id.clone()))?;
    EngineSpan::new(span.start_byte, span.end_byte, artifact_bytes)?;
    Ok(())
}

fn engine_key(key: &adapter::SymbolKey) -> Result<EngineKey, HostError> {
    let stability = match adapter::SymbolStability::try_from(key.stability)
        .map_err(|_| HostError::InvalidFact("symbol key has unknown stability"))?
    {
        adapter::SymbolStability::Snapshot => SymbolStability::Snapshot,
        adapter::SymbolStability::CrossSnapshot => SymbolStability::CrossSnapshot,
        adapter::SymbolStability::Unspecified => {
            return Err(HostError::InvalidFact("symbol key omitted stability"));
        }
    };
    Ok(EngineKey::new_with_stability(&key.scheme, key.scheme_version, &key.value, stability)?)
}

fn completeness(value: i32) -> Result<Completeness, HostError> {
    match adapter::CompletenessStatus::try_from(value)
        .map_err(|_| HostError::InvalidFact("unknown completeness status"))?
    {
        adapter::CompletenessStatus::Complete => Ok(Completeness::Complete),
        adapter::CompletenessStatus::Partial => Ok(Completeness::Partial),
        adapter::CompletenessStatus::Unsupported => Ok(Completeness::Unsupported),
        adapter::CompletenessStatus::Failed => Ok(Completeness::Failed),
        adapter::CompletenessStatus::NotRequested => Ok(Completeness::NotRequested),
        adapter::CompletenessStatus::Unspecified => {
            Err(HostError::InvalidFact("completeness status is unspecified"))
        }
    }
}

fn edge_reason(value: i32) -> &'static str {
    match adapter::RetentionEdgeKind::try_from(value) {
        Ok(adapter::RetentionEdgeKind::Reference) => "semantic reference",
        Ok(adapter::RetentionEdgeKind::Call) => "call",
        Ok(adapter::RetentionEdgeKind::TypeUse) => "type use",
        Ok(adapter::RetentionEdgeKind::DeclarationOwner) => "declaration owner",
        _ => "unknown",
    }
}

#[derive(Debug, Error)]
pub enum HostError {
    #[error("could not start adapter {program}: {source}")]
    Spawn {
        program: String,
        #[source]
        source: std::io::Error,
    },
    #[error("spawned adapter did not expose {0}")]
    MissingPipe(&'static str),
    #[error("invalid adapter host limits: {0}")]
    InvalidLimits(&'static str),
    #[error(transparent)]
    Protocol(#[from] FrameError),
    #[error("adapter protocol reader failed: {0}")]
    ProtocolReader(String),
    #[error("adapter timed out during {operation}; stderr: {stderr}")]
    Timeout { operation: &'static str, stderr: String },
    #[error("adapter terminated unexpectedly; stderr: {stderr}")]
    Terminated { stderr: String },
    #[error("adapter returned an unexpected response: {0}")]
    UnexpectedResponse(String),
    #[error("adapter is missing required capability {0}")]
    MissingCapability(&'static str),
    #[error("adapter error {code}: {message} (retryable: {retryable})")]
    Adapter { code: String, message: String, retryable: bool },
    #[error("adapter emitted {facts} facts, exceeding the limit of {limit}")]
    FactLimit { facts: usize, limit: usize },
    #[error("invalid adapter fact: {0}")]
    InvalidFact(&'static str),
    #[error("invalid portable artifact id: {0}")]
    InvalidArtifactId(String),
    #[error("fact references unknown artifact: {0}")]
    UnknownArtifact(String),
    #[error(transparent)]
    Model(#[from] ModelError),
}

#[cfg(test)]
mod tests {
    use super::*;

    fn key(value: &[u8]) -> adapter::SymbolKey {
        adapter::SymbolKey {
            scheme: "test".to_owned(),
            scheme_version: 1,
            value: value.to_vec(),
            stability: adapter::SymbolStability::CrossSnapshot as i32,
        }
    }

    fn span(start: u64, end: u64) -> adapter::SourceSpan {
        adapter::SourceSpan {
            artifact_id: "lib/main.dart".to_owned(),
            start_byte: start,
            end_byte: end,
        }
    }

    fn analysis() -> AdapterAnalysis {
        AdapterAnalysis {
            artifacts: vec![adapter::Artifact {
                id: "lib/main.dart".to_owned(),
                language: "dart".to_owned(),
                byte_length: 100,
                content_digest: Some(adapter::ContentDigest {
                    algorithm: "sha256".to_owned(),
                    value: vec![1; 32],
                }),
                source_encoding: adapter::SourceEncoding::Utf8 as i32,
                origin: adapter::ArtifactOrigin::Source as i32,
            }],
            symbols: vec![
                adapter::Symbol {
                    key: Some(key(b"main")),
                    display_name: "main".to_owned(),
                    qualified_name: "main".to_owned(),
                    kind: adapter::SymbolKind::Function as i32,
                    declaration: Some(span(0, 4)),
                    visibility: adapter::Visibility::Public as i32,
                    export_status: adapter::ExportStatus::Unspecified as i32,
                },
                adapter::Symbol {
                    key: Some(key(b"dead")),
                    display_name: "dead".to_owned(),
                    qualified_name: "dead".to_owned(),
                    kind: adapter::SymbolKind::Function as i32,
                    declaration: Some(span(10, 14)),
                    visibility: adapter::Visibility::Public as i32,
                    export_status: adapter::ExportStatus::Unspecified as i32,
                },
            ],
            roots: vec![adapter::Root {
                symbol: Some(key(b"main")),
                kind: adapter::RootKind::EntryPoint as i32,
                evidence: Some(span(0, 4)),
                reason_code: "test.main".to_owned(),
            }],
            complete: Some(adapter::Complete {
                status: adapter::CompletionStatus::Partial as i32,
                dimensions: vec![
                    adapter::Completeness {
                        capability_id: SOURCE_DISCOVERY_DIMENSION.to_owned(),
                        status: adapter::CompletenessStatus::Complete as i32,
                        reason_code: String::new(),
                    },
                    adapter::Completeness {
                        capability_id: SEMANTIC_RESOLUTION_DIMENSION.to_owned(),
                        status: adapter::CompletenessStatus::Complete as i32,
                        reason_code: String::new(),
                    },
                    adapter::Completeness {
                        capability_id: ROOTS_DIMENSION.to_owned(),
                        status: adapter::CompletenessStatus::Partial as i32,
                        reason_code: "test.partial_roots".to_owned(),
                    },
                    adapter::Completeness {
                        capability_id: RETENTION_EDGES_DIMENSION.to_owned(),
                        status: adapter::CompletenessStatus::Partial as i32,
                        reason_code: "test.partial_edges".to_owned(),
                    },
                    adapter::Completeness {
                        capability_id: DYNAMIC_BEHAVIOR_DIMENSION.to_owned(),
                        status: adapter::CompletenessStatus::Partial as i32,
                        reason_code: "test.partial_dynamic".to_owned(),
                    },
                ],
            }),
            ..AdapterAnalysis::default()
        }
    }

    #[test]
    fn valid_facts_build_a_candidate_graph() {
        let analysis = analysis();
        analysis.validate().expect("fixture facts must be valid");
        let graph = analysis.retention_graph().expect("fixture graph must build");
        let result = graph
            .analyze_dead_code(
                analysis.dead_code_completeness().expect("fixture completeness must convert"),
                hyena_engine::DeadCodeMode::IncludeCandidates,
            )
            .expect("candidate mode must accept partial facts");

        assert_eq!(result.unused.len(), 1);
        assert_eq!(result.unused[0].symbol.value(), b"dead");
        assert_eq!(result.unused[0].certainty, hyena_engine::FindingCertainty::CandidateUnused);
    }

    #[test]
    fn validation_rejects_out_of_bounds_spans() {
        let mut analysis = analysis();
        analysis.symbols[0].declaration = Some(span(0, 101));

        assert!(matches!(analysis.validate(), Err(HostError::Model(_))));
    }

    #[test]
    fn validation_rejects_non_portable_artifact_ids() {
        let mut analysis = analysis();
        analysis.artifacts[0].id = "../main.dart".to_owned();

        assert!(matches!(analysis.validate(), Err(HostError::InvalidArtifactId(_))));
    }
}
