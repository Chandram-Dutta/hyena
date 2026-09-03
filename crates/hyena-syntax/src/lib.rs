#![forbid(unsafe_code)]

use serde::Serialize;
use thiserror::Error;
use tree_sitter::{Language, Node, Parser};

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum SyntaxLanguage {
    Dart,
}

impl SyntaxLanguage {
    pub const fn id(self) -> &'static str {
        match self {
            Self::Dart => "dart",
        }
    }

    fn grammar(self) -> Language {
        match self {
            Self::Dart => tree_sitter_dart::LANGUAGE.into(),
        }
    }
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ParseSummary {
    pub language: &'static str,
    pub source_bytes: usize,
    pub root_kind: String,
    pub named_nodes: usize,
    pub error_nodes: usize,
    pub missing_nodes: usize,
}

impl ParseSummary {
    pub const fn is_error_free(&self) -> bool {
        self.error_nodes == 0 && self.missing_nodes == 0
    }
}

pub fn parse_summary(language: SyntaxLanguage, source: &[u8]) -> Result<ParseSummary, SyntaxError> {
    let mut parser = Parser::new();
    parser.set_language(&language.grammar())?;
    let tree = parser.parse(source, None).ok_or(SyntaxError::ParseCancelled)?;
    let root = tree.root_node();
    let counts = count_nodes(root);

    Ok(ParseSummary {
        language: language.id(),
        source_bytes: source.len(),
        root_kind: root.kind().to_owned(),
        named_nodes: counts.named,
        error_nodes: counts.errors,
        missing_nodes: counts.missing,
    })
}

#[derive(Default)]
struct NodeCounts {
    named: usize,
    errors: usize,
    missing: usize,
}

fn count_nodes(root: Node<'_>) -> NodeCounts {
    let mut counts = NodeCounts::default();
    let mut pending = vec![root];

    while let Some(node) = pending.pop() {
        counts.named += usize::from(node.is_named());
        counts.errors += usize::from(node.is_error());
        counts.missing += usize::from(node.is_missing());
        let mut cursor = node.walk();
        pending.extend(node.children(&mut cursor));
    }

    counts
}

#[derive(Debug, Error)]
pub enum SyntaxError {
    #[error("the {0} grammar is incompatible with this Tree-sitter runtime")]
    IncompatibleGrammar(#[from] tree_sitter::LanguageError),
    #[error("Tree-sitter cancelled parsing before producing a syntax tree")]
    ParseCancelled,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_current_dart_syntax() {
        let source = br#"
sealed class Shape {}
final class Square extends Shape {
  Square(this.side);
  final double side;
  double area() => side * side;
}
"#;

        let summary = parse_summary(SyntaxLanguage::Dart, source)
            .expect("the bundled Dart grammar must load and parse");

        assert_eq!(summary.language, "dart");
        assert_eq!(summary.root_kind, "source_file");
        assert!(summary.named_nodes > 10);
        assert!(summary.is_error_free(), "unexpected parse errors: {summary:?}");
    }

    #[test]
    fn reports_recovered_syntax_errors_without_rejecting_the_tree() {
        let summary = parse_summary(SyntaxLanguage::Dart, b"void main( {")
            .expect("Tree-sitter should return a recovered tree");

        assert!(!summary.is_error_free());
        assert!(summary.error_nodes > 0 || summary.missing_nodes > 0);
    }
}
