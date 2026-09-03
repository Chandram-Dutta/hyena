#![forbid(unsafe_code)]

use std::{
    ffi::OsString,
    fs,
    io::{self, Write},
    path::{Component, Path, PathBuf},
    process::ExitCode,
    time::Duration,
};

use clap::{Parser, Subcommand, ValueEnum};
use hyena_adapter_host::{AdapterClient, HostError, HostLimits};
use hyena_engine::{AnalysisError, DeadCodeMode, FindingCertainty, SymbolKey, SymbolStability};
use hyena_protocol::{PROTOCOL_MAJOR, PROTOCOL_MINOR, adapter};
use hyena_syntax::{SyntaxError, SyntaxLanguage, parse_summary};
use serde::Serialize;
use thiserror::Error;

#[derive(Debug, Parser)]
#[command(
    name = "hyena",
    version,
    about = "Fast, reliable multi-language static analysis",
    long_about = "Hyena is an experimental multi-language static-analysis engine. Phase 0 provides a validated core model, an experimental adapter handshake, and syntax inspection; semantic dead-code analysis is not exposed yet."
)]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Debug, Subcommand)]
enum Command {
    /// Show installed engine capabilities and experimental protocol version.
    Doctor,
    /// Run semantic dead-code analysis through a Dart adapter subprocess.
    Analyze {
        /// Dart package, directory, or source file to analyze.
        path: PathBuf,
        /// Compiled Dart adapter executable.
        #[arg(long, default_value = "target/hyena-dart-adapter")]
        adapter: PathBuf,
        /// Include explicitly labeled candidates when analysis is incomplete.
        #[arg(long)]
        include_candidates: bool,
        /// Maximum wall-clock seconds for an adapter handshake or analysis.
        #[arg(long, default_value_t = 60)]
        timeout_seconds: u64,
    },
    /// Parse one file using a bundled Tree-sitter grammar.
    Syntax {
        #[arg(value_enum, long)]
        language: LanguageArgument,
        path: PathBuf,
    },
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum LanguageArgument {
    Dart,
}

impl From<LanguageArgument> for SyntaxLanguage {
    fn from(language: LanguageArgument) -> Self {
        match language {
            LanguageArgument::Dart => Self::Dart,
        }
    }
}

fn main() -> ExitCode {
    match run(Cli::parse()) {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("hyena: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run(cli: Cli) -> Result<(), CliError> {
    match cli.command {
        Command::Doctor => {
            println!("Hyena {}", env!("CARGO_PKG_VERSION"));
            println!("adapter protocol: {PROTOCOL_MAJOR}.{PROTOCOL_MINOR} (experimental)");
            println!("syntax languages: dart");
            println!("semantic adapters: dart (experimental subprocess)");
            Ok(())
        }
        Command::Analyze { path, adapter, include_candidates, timeout_seconds } => {
            analyze_dart(path, adapter, include_candidates, timeout_seconds)
        }
        Command::Syntax { language, path } => {
            let source = fs::read(&path)
                .map_err(|source| CliError::ReadSource { path: path.clone(), source })?;
            let summary = parse_summary(language.into(), &source)?;
            let stdout = io::stdout();
            let mut output = stdout.lock();
            serde_json::to_writer_pretty(&mut output, &summary)?;
            writeln!(output)?;
            Ok(())
        }
    }
}

fn analyze_dart(
    path: PathBuf,
    adapter: PathBuf,
    include_candidates: bool,
    timeout_seconds: u64,
) -> Result<(), CliError> {
    let (workspace_root, target) = dart_workspace_target(&path)?;
    let limits = HostLimits {
        request_timeout: Duration::from_secs(timeout_seconds),
        ..HostLimits::default()
    };
    let mut client = AdapterClient::spawn(adapter.as_os_str(), &[] as &[OsString], limits)?;
    let adapter_info = client.info().clone();
    let facts = client.analyze(&workspace_root, &target)?;
    let completeness = facts.dead_code_completeness()?;
    let graph = facts.retention_graph()?;
    let mode =
        if include_candidates { DeadCodeMode::IncludeCandidates } else { DeadCodeMode::ProvenOnly };
    let analysis = match graph.analyze_dead_code(completeness, mode) {
        Ok(analysis) => analysis,
        Err(AnalysisError::IncompleteForProvenUnused { incomplete_dimensions }) => {
            return Err(CliError::CandidatesRequired { incomplete_dimensions });
        }
        Err(AnalysisError::UnavailableForDeadCode { unavailable_dimensions }) => {
            return Err(CliError::AnalysisUnavailable { unavailable_dimensions });
        }
    };

    let mut findings = analysis
        .unused
        .iter()
        .map(|finding| {
            let symbol = facts
                .symbols
                .iter()
                .find(|symbol| {
                    symbol
                        .key
                        .as_ref()
                        .is_some_and(|key| protocol_key_matches(&finding.symbol, key))
                })
                .ok_or(CliError::MissingFindingSymbol)?;
            let span = symbol.declaration.as_ref().ok_or(CliError::MissingFindingSymbol)?;
            Ok(FindingOutput {
                certainty: match finding.certainty {
                    FindingCertainty::ProvenUnused => "provenUnused",
                    FindingCertainty::CandidateUnused => "candidateUnused",
                },
                name: symbol.qualified_name.clone(),
                kind: symbol_kind(symbol.kind),
                artifact: span.artifact_id.clone(),
                start_byte: span.start_byte,
                end_byte: span.end_byte,
            })
        })
        .collect::<Result<Vec<_>, CliError>>()?;
    findings.sort_by(|left, right| {
        (&left.artifact, left.start_byte, left.end_byte, &left.name).cmp(&(
            &right.artifact,
            right.start_byte,
            right.end_byte,
            &right.name,
        ))
    });
    let completeness = facts
        .complete
        .as_ref()
        .map(|complete| {
            complete
                .dimensions
                .iter()
                .map(|dimension| CompletenessOutput {
                    dimension: dimension.capability_id.clone(),
                    status: completeness_status(dimension.status),
                    reason_code: dimension.reason_code.clone(),
                })
                .collect()
        })
        .unwrap_or_default();
    let diagnostics = facts
        .diagnostics
        .iter()
        .map(|diagnostic| DiagnosticOutput {
            severity: diagnostic_severity(diagnostic.severity),
            code: diagnostic.code.clone(),
            message: diagnostic.message.clone(),
            artifact: diagnostic.span.as_ref().map(|span| span.artifact_id.clone()),
            start_byte: diagnostic.span.as_ref().map(|span| span.start_byte),
            end_byte: diagnostic.span.as_ref().map(|span| span.end_byte),
        })
        .collect::<Vec<_>>();
    let output = AnalysisOutput {
        adapter: AdapterOutput { name: adapter_info.name, version: adapter_info.version },
        summary: SummaryOutput {
            artifacts: facts.artifacts.len(),
            symbols: facts.symbols.len(),
            retention_edges: facts.retention_edges.len(),
            roots: facts.roots.len(),
            findings: findings.len(),
        },
        completeness,
        findings,
        diagnostics,
    };

    let stdout = io::stdout();
    let mut writer = stdout.lock();
    serde_json::to_writer_pretty(&mut writer, &output)?;
    writeln!(writer)?;
    Ok(())
}

fn dart_workspace_target(path: &Path) -> Result<(PathBuf, String), CliError> {
    let target = fs::canonicalize(path)
        .map_err(|source| CliError::CanonicalizeTarget { path: path.to_owned(), source })?;
    let target_directory = if target.is_dir() {
        target.as_path()
    } else {
        target.parent().ok_or_else(|| CliError::NoTargetParent { path: target.clone() })?
    };
    let mut candidate = Some(target_directory);
    let mut package_root = None;
    while let Some(directory) = candidate {
        if directory.join("pubspec.yaml").is_file() {
            package_root = Some(directory.to_owned());
            break;
        }
        candidate = directory.parent();
    }
    let workspace_root = package_root.unwrap_or_else(|| target_directory.to_owned());
    let relative = target.strip_prefix(&workspace_root).map_err(|_| CliError::NonPortableTarget)?;
    let portable = if relative.as_os_str().is_empty() {
        ".".to_owned()
    } else {
        relative
            .components()
            .map(|component| match component {
                Component::Normal(value) => value.to_str().ok_or(CliError::NonPortableTarget),
                _ => Err(CliError::NonPortableTarget),
            })
            .collect::<Result<Vec<_>, _>>()?
            .join("/")
    };
    Ok((workspace_root, portable))
}

fn protocol_key_matches(key: &SymbolKey, protocol: &adapter::SymbolKey) -> bool {
    key.scheme() == protocol.scheme
        && key.scheme_version() == protocol.scheme_version
        && key.value() == protocol.value
        && matches!(
            (key.stability(), adapter::SymbolStability::try_from(protocol.stability)),
            (SymbolStability::Snapshot, Ok(adapter::SymbolStability::Snapshot))
                | (SymbolStability::CrossSnapshot, Ok(adapter::SymbolStability::CrossSnapshot))
        )
}

fn symbol_kind(value: i32) -> &'static str {
    match adapter::SymbolKind::try_from(value) {
        Ok(kind) => kind.as_str_name(),
        Err(_) => "SYMBOL_KIND_UNSPECIFIED",
    }
}

fn completeness_status(value: i32) -> &'static str {
    match adapter::CompletenessStatus::try_from(value) {
        Ok(adapter::CompletenessStatus::Complete) => "complete",
        Ok(adapter::CompletenessStatus::Partial) => "partial",
        Ok(adapter::CompletenessStatus::Unsupported) => "unsupported",
        Ok(adapter::CompletenessStatus::Failed) => "failed",
        Ok(adapter::CompletenessStatus::NotRequested) => "notRequested",
        _ => "unspecified",
    }
}

fn diagnostic_severity(value: i32) -> &'static str {
    match adapter::DiagnosticSeverity::try_from(value) {
        Ok(adapter::DiagnosticSeverity::Info) => "info",
        Ok(adapter::DiagnosticSeverity::Warning) => "warning",
        Ok(adapter::DiagnosticSeverity::Error) => "error",
        _ => "unspecified",
    }
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct AnalysisOutput {
    adapter: AdapterOutput,
    summary: SummaryOutput,
    completeness: Vec<CompletenessOutput>,
    findings: Vec<FindingOutput>,
    diagnostics: Vec<DiagnosticOutput>,
}

#[derive(Serialize)]
struct AdapterOutput {
    name: String,
    version: String,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct SummaryOutput {
    artifacts: usize,
    symbols: usize,
    retention_edges: usize,
    roots: usize,
    findings: usize,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct CompletenessOutput {
    dimension: String,
    status: &'static str,
    reason_code: String,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct FindingOutput {
    certainty: &'static str,
    name: String,
    kind: &'static str,
    artifact: String,
    start_byte: u64,
    end_byte: u64,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct DiagnosticOutput {
    severity: &'static str,
    code: String,
    message: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    artifact: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    start_byte: Option<u64>,
    #[serde(skip_serializing_if = "Option::is_none")]
    end_byte: Option<u64>,
}

#[derive(Debug, Error)]
enum CliError {
    #[error("could not read {path}: {source}")]
    ReadSource { path: PathBuf, source: io::Error },
    #[error("could not resolve target {path}: {source}")]
    CanonicalizeTarget { path: PathBuf, source: io::Error },
    #[error("target has no parent directory: {path}")]
    NoTargetParent { path: PathBuf },
    #[error("target cannot be represented as a portable workspace-relative path")]
    NonPortableTarget,
    #[error(transparent)]
    AdapterHost(#[from] HostError),
    #[error(
        "Dart analysis is incomplete in {incomplete_dimensions:?}; rerun with \
         --include-candidates to see explicitly labeled candidates"
    )]
    CandidatesRequired { incomplete_dimensions: Vec<&'static str> },
    #[error("Dart dead-code analysis is unavailable in {unavailable_dimensions:?}")]
    AnalysisUnavailable { unavailable_dimensions: Vec<&'static str> },
    #[error("adapter finding references a missing symbol or declaration")]
    MissingFindingSymbol,
    #[error(transparent)]
    Syntax(#[from] SyntaxError),
    #[error("could not serialize syntax summary: {0}")]
    Serialize(#[from] serde_json::Error),
    #[error("could not write command output: {0}")]
    Write(#[from] io::Error),
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn language_arguments_map_to_syntax_languages() {
        assert_eq!(SyntaxLanguage::from(LanguageArgument::Dart), SyntaxLanguage::Dart);
    }
}
