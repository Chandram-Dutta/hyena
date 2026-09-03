# Hyena contributor guidance

## Project

Hyena is an experimental multi-language static-analysis engine. The core is Rust; language-specific semantic frontends communicate through a versioned process protocol.

## Required checks

Run these before considering a code change complete:

```bash
cargo fmt --all -- --check
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo test --workspace --all-targets --all-features --locked
```

## Boundaries

- Keep wire-generated Protobuf types inside `hyena-protocol`; convert them into validated domain types at the boundary.
- Do not expose Tree-sitter node types or language compiler types from core APIs.
- Treat SCIP as an interchange format, not the internal source of truth.
- Do not infer semantic references from matching names.
- Preserve explicit unknown, unsupported, partial, failed, and not-requested states.
- Keep persistent caches disposable and out of public compatibility contracts.
- Do not introduce native dynamic plugin ABIs. Public adapters are supervised subprocesses.
- Every externally visible order must be deterministic.
- Do not claim code is proven unused when required analysis dimensions are incomplete.

## Scope discipline

This repository is in Phase 0. Add abstractions only after a Dart and TypeScript vertical slice demonstrate the need. Protocol package `v0` is experimental and must not be described as stable.
