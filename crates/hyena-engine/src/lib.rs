#![forbid(unsafe_code)]

use std::collections::{BTreeMap, BTreeSet};

use serde::Serialize;
use thiserror::Error;

/// An opaque semantic identity supplied by a language frontend.
///
/// The engine compares and orders keys but never interprets `value`.
#[derive(Clone, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct SymbolKey {
    scheme: String,
    scheme_version: u32,
    value: String,
}

impl SymbolKey {
    pub fn new(
        scheme: impl Into<String>,
        scheme_version: u32,
        value: impl Into<String>,
    ) -> Result<Self, ModelError> {
        let scheme = scheme.into();
        let value = value.into();
        if scheme.trim().is_empty() {
            return Err(ModelError::EmptySymbolComponent { component: "scheme" });
        }
        if scheme_version == 0 {
            return Err(ModelError::ZeroSymbolSchemeVersion);
        }
        if value.is_empty() {
            return Err(ModelError::EmptySymbolComponent { component: "value" });
        }
        Ok(Self { scheme, scheme_version, value })
    }

    pub fn scheme(&self) -> &str {
        &self.scheme
    }

    pub fn scheme_version(&self) -> u32 {
        self.scheme_version
    }

    pub fn value(&self) -> &str {
        &self.value
    }
}

/// A canonical zero-based, half-open byte span into a specific source artifact.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct SourceSpan {
    start_byte: u64,
    end_byte: u64,
}

impl SourceSpan {
    pub fn new(start_byte: u64, end_byte: u64, artifact_bytes: u64) -> Result<Self, ModelError> {
        if start_byte > end_byte || end_byte > artifact_bytes {
            return Err(ModelError::InvalidSourceSpan { start_byte, end_byte, artifact_bytes });
        }
        Ok(Self { start_byte, end_byte })
    }

    pub fn start_byte(self) -> u64 {
        self.start_byte
    }

    pub fn end_byte(self) -> u64 {
        self.end_byte
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Symbol {
    key: SymbolKey,
    display_name: String,
}

impl Symbol {
    pub fn new(key: SymbolKey, display_name: impl Into<String>) -> Result<Self, ModelError> {
        let display_name = display_name.into();
        if display_name.is_empty() {
            return Err(ModelError::EmptyDisplayName);
        }
        Ok(Self { key, display_name })
    }

    pub fn key(&self) -> &SymbolKey {
        &self.key
    }

    pub fn display_name(&self) -> &str {
        &self.display_name
    }
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct RetentionEdge {
    source: SymbolKey,
    target: SymbolKey,
    reason: String,
}

impl RetentionEdge {
    pub fn new(
        source: SymbolKey,
        target: SymbolKey,
        reason: impl Into<String>,
    ) -> Result<Self, ModelError> {
        let reason = reason.into();
        if reason.is_empty() {
            return Err(ModelError::EmptyRetentionReason);
        }
        Ok(Self { source, target, reason })
    }

    pub fn source(&self) -> &SymbolKey {
        &self.source
    }

    pub fn target(&self) -> &SymbolKey {
        &self.target
    }

    pub fn reason(&self) -> &str {
        &self.reason
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Completeness {
    Complete,
    Partial,
    Unsupported,
    Failed,
    NotRequested,
}

/// Completeness dimensions required before the core may claim a symbol is
/// proven unused.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct DeadCodeCompleteness {
    pub source_discovery: Completeness,
    pub semantic_resolution: Completeness,
    pub roots: Completeness,
    pub retention_edges: Completeness,
    pub dynamic_behavior: Completeness,
}

impl DeadCodeCompleteness {
    pub const fn complete() -> Self {
        Self {
            source_discovery: Completeness::Complete,
            semantic_resolution: Completeness::Complete,
            roots: Completeness::Complete,
            retention_edges: Completeness::Complete,
            dynamic_behavior: Completeness::Complete,
        }
    }

    fn incomplete_dimensions(self) -> Vec<&'static str> {
        [
            ("source_discovery", self.source_discovery),
            ("semantic_resolution", self.semantic_resolution),
            ("roots", self.roots),
            ("retention_edges", self.retention_edges),
            ("dynamic_behavior", self.dynamic_behavior),
        ]
        .into_iter()
        .filter_map(|(name, status)| (status != Completeness::Complete).then_some(name))
        .collect()
    }
}

/// A validated retention graph. Ordering is independent of input order.
#[derive(Debug)]
pub struct RetentionGraph {
    symbols: BTreeMap<SymbolKey, Symbol>,
    roots: BTreeSet<SymbolKey>,
    outgoing: BTreeMap<SymbolKey, BTreeSet<SymbolKey>>,
}

impl RetentionGraph {
    pub fn new(
        symbols: Vec<Symbol>,
        roots: Vec<SymbolKey>,
        edges: Vec<RetentionEdge>,
    ) -> Result<Self, ModelError> {
        let mut by_key = BTreeMap::new();
        for symbol in symbols {
            let key = symbol.key.clone();
            if by_key.insert(key.clone(), symbol).is_some() {
                return Err(ModelError::DuplicateSymbol { key });
            }
        }

        let roots = roots.into_iter().collect::<BTreeSet<_>>();
        for root in &roots {
            if !by_key.contains_key(root) {
                return Err(ModelError::UnknownRoot { key: root.clone() });
            }
        }

        let mut outgoing =
            by_key.keys().cloned().map(|key| (key, BTreeSet::new())).collect::<BTreeMap<_, _>>();
        for edge in edges {
            if !by_key.contains_key(&edge.source) {
                return Err(ModelError::UnknownEdgeSource { key: edge.source });
            }
            if !by_key.contains_key(&edge.target) {
                return Err(ModelError::UnknownEdgeTarget { key: edge.target });
            }
            outgoing
                .get_mut(&edge.source)
                .expect("validated symbol must have an adjacency entry")
                .insert(edge.target);
        }

        Ok(Self { symbols: by_key, roots, outgoing })
    }

    pub fn analyze(
        &self,
        completeness: DeadCodeCompleteness,
    ) -> Result<ReachabilityAnalysis, AnalysisError> {
        let incomplete_dimensions = completeness.incomplete_dimensions();
        if !incomplete_dimensions.is_empty() {
            return Err(AnalysisError::IncompleteForProvenUnused { incomplete_dimensions });
        }

        let mut reachable = self.roots.clone();
        let mut pending = self.roots.iter().cloned().collect::<Vec<_>>();
        while let Some(source) = pending.pop() {
            for target in
                self.outgoing.get(&source).expect("validated symbol must have an adjacency entry")
            {
                if reachable.insert(target.clone()) {
                    pending.push(target.clone());
                }
            }
        }

        let unused = self.symbols.keys().filter(|key| !reachable.contains(*key)).cloned().collect();
        Ok(ReachabilityAnalysis { reachable: reachable.into_iter().collect(), unused })
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ReachabilityAnalysis {
    pub reachable: Vec<SymbolKey>,
    pub unused: Vec<SymbolKey>,
}

#[derive(Debug, Error, Eq, PartialEq)]
pub enum ModelError {
    #[error("symbol {component} must not be empty")]
    EmptySymbolComponent { component: &'static str },
    #[error("symbol scheme version must be greater than zero")]
    ZeroSymbolSchemeVersion,
    #[error("symbol display name must not be empty")]
    EmptyDisplayName,
    #[error("retention edge reason must not be empty")]
    EmptyRetentionReason,
    #[error(
        "invalid source span [{start_byte}, {end_byte}) for an artifact of {artifact_bytes} bytes"
    )]
    InvalidSourceSpan { start_byte: u64, end_byte: u64, artifact_bytes: u64 },
    #[error("duplicate symbol: {key:?}")]
    DuplicateSymbol { key: SymbolKey },
    #[error("root references an unknown symbol: {key:?}")]
    UnknownRoot { key: SymbolKey },
    #[error("retention edge source is unknown: {key:?}")]
    UnknownEdgeSource { key: SymbolKey },
    #[error("retention edge target is unknown: {key:?}")]
    UnknownEdgeTarget { key: SymbolKey },
}

#[derive(Debug, Error, Eq, PartialEq)]
pub enum AnalysisError {
    #[error("proven-unused analysis requires complete dimensions: {incomplete_dimensions:?}")]
    IncompleteForProvenUnused { incomplete_dimensions: Vec<&'static str> },
}

#[cfg(test)]
mod tests {
    use super::*;

    fn key(value: &str) -> SymbolKey {
        SymbolKey::new("test", 1, value).expect("fixture symbol key must be valid")
    }

    fn symbol(value: &str) -> Symbol {
        Symbol::new(key(value), value).expect("fixture symbol must be valid")
    }

    fn edge(source: &str, target: &str) -> RetentionEdge {
        RetentionEdge::new(key(source), key(target), "test reference")
            .expect("fixture edge must be valid")
    }

    #[test]
    fn source_spans_are_zero_based_half_open_and_bounded() {
        assert_eq!(SourceSpan::new(0, 4, 4), Ok(SourceSpan { start_byte: 0, end_byte: 4 }));
        assert!(matches!(SourceSpan::new(5, 4, 10), Err(ModelError::InvalidSourceSpan { .. })));
        assert!(matches!(SourceSpan::new(0, 11, 10), Err(ModelError::InvalidSourceSpan { .. })));
    }

    #[test]
    fn reachability_handles_cycles_and_returns_stable_order() {
        let graph = RetentionGraph::new(
            vec![symbol("dead-b"), symbol("main"), symbol("live"), symbol("dead-a")],
            vec![key("main")],
            vec![edge("dead-b", "dead-a"), edge("main", "live"), edge("dead-a", "dead-b")],
        )
        .expect("fixture graph must be valid");

        let result = graph
            .analyze(DeadCodeCompleteness::complete())
            .expect("complete graph must be analyzable");

        assert_eq!(result.reachable, vec![key("live"), key("main")]);
        assert_eq!(result.unused, vec![key("dead-a"), key("dead-b")]);
    }

    #[test]
    fn input_order_does_not_change_serialized_results() {
        let left = RetentionGraph::new(
            vec![symbol("main"), symbol("used"), symbol("unused")],
            vec![key("main")],
            vec![edge("main", "used")],
        )
        .expect("fixture graph must be valid")
        .analyze(DeadCodeCompleteness::complete())
        .expect("fixture graph must be complete");
        let right = RetentionGraph::new(
            vec![symbol("unused"), symbol("used"), symbol("main")],
            vec![key("main")],
            vec![edge("main", "used")],
        )
        .expect("fixture graph must be valid")
        .analyze(DeadCodeCompleteness::complete())
        .expect("fixture graph must be complete");

        assert_eq!(
            serde_json::to_string(&left).expect("result must serialize"),
            serde_json::to_string(&right).expect("result must serialize")
        );
    }

    #[test]
    fn incomplete_graph_cannot_claim_proven_unused_symbols() {
        let graph = RetentionGraph::new(vec![symbol("main")], vec![key("main")], vec![])
            .expect("fixture graph must be valid");
        let completeness = DeadCodeCompleteness {
            semantic_resolution: Completeness::Partial,
            ..DeadCodeCompleteness::complete()
        };

        assert_eq!(
            graph.analyze(completeness),
            Err(AnalysisError::IncompleteForProvenUnused {
                incomplete_dimensions: vec!["semantic_resolution"]
            })
        );
    }

    #[test]
    fn graph_rejects_edges_to_unknown_symbols() {
        assert!(matches!(
            RetentionGraph::new(
                vec![symbol("main")],
                vec![key("main")],
                vec![edge("main", "missing")],
            ),
            Err(ModelError::UnknownEdgeTarget { .. })
        ));
    }
}
