# ADR 0001: Separate the core from language frontends

- **Status:** Accepted
- **Date:** 2026-09-03

## Context

Hyena must analyze languages with incompatible syntax, symbol systems, build variants, type systems, dispatch rules, and metaprogramming. A universal AST would either leak one language's assumptions or become an unbounded compiler schema. Tree-sitter has broad syntax coverage but does not provide compiler-grade semantic resolution. LSP implementations target editor interactions and vary in whole-project indexing support. SCIP is a useful semantic index format but does not encode all facts Hyena needs for reachability and complexity.

## Decision

Use a Rust core with language-specific frontends.

The core owns validated common facts, deterministic graph algorithms, finding policy, output, orchestration, and eventually caching. Frontends own project discovery and language semantics. Tree-sitter language packs may produce syntax facts. Compiler-backed frontends or SCIP imports produce semantic facts.

The common model normalizes evidence-bearing artifacts, symbols, occurrences, relations, roots, capabilities, and completeness. It does not normalize complete language ASTs. SCIP is an accepted interchange source, not the internal representation.

## Consequences

- Adding a language requires a frontend or syntax pack but not core changes for ordinary facts.
- Language-specific semantic behavior stays testable at the frontend boundary.
- Some analyses are unavailable when a frontend cannot provide the required facts.
- Syntax-only support can be broad and fast but cannot claim compiler-grade dead-code certainty.
- Cross-language links require explicit bridge evidence rather than name matching.

## Alternatives considered

- **Universal AST:** rejected because semantic and build-system differences do not normalize reliably.
- **Tree-sitter only:** retained for syntax, rejected as the source of semantic truth.
- **LSP as the universal frontend:** rejected as a mandatory contract because LSP servers are editor-oriented and capability coverage varies.
- **SCIP as the internal IR:** rejected because Hyena also requires roots, retention, variants, CFG policy, and completeness.
