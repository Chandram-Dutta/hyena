# Hyena

Hyena is an experimental, local-first engine for fast and reliable static analysis across programming languages.

The project is in **Phase 0**. It currently provides:

- a Rust workspace with a validated semantic identity and retention-graph model;
- deterministic reachability analysis that refuses to claim proven dead code from incomplete inputs;
- an experimental, bounded Protobuf control protocol for language adapters;
- a Tree-sitter syntax host with initial Dart grammar integration;
- an early `hyena` CLI for environment diagnostics and syntax inspection.

It does **not** yet expose production dead-code or complexity analysis. Protocol package `hyena.adapter.v0` is intentionally unstable until Dart and TypeScript vertical slices validate the contract.

## Architecture

```text
┌────────────────────┐     ┌────────────────────────────┐
│ CLI / future API   │────▶│ Rust core                  │
└────────────────────┘     │ validation · graph · rules │
                           └─────────────┬──────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
      ┌─────────────────────┐                        ┌────────────────────────┐
      │ Tree-sitter packs   │                        │ Semantic frontends     │
      │ fast syntax facts   │                        │ compiler / SCIP-backed │
      └─────────────────────┘                        └────────────────────────┘
```

Hyena normalizes evidence-bearing facts, not language ASTs. Language frontends remain responsible for project semantics, symbol resolution, exports, dispatch, reflection, FFI, and build variants. See the [initial proposal](docs/proposal.md) and [architecture decisions](docs/adr/).

## Development

The repository pins Rust 1.98.0. On an Amp orb, `.agents/setup` installs the toolchain and builds the workspace. Elsewhere, install [rustup](https://rustup.rs/) and run:

```bash
cargo build --workspace --all-targets --locked
cargo test --workspace --all-targets --all-features --locked
cargo clippy --workspace --all-targets --all-features -- -D warnings
```

Try the current CLI surface:

```bash
cargo run -p hyena-cli -- doctor
cargo run -p hyena-cli -- syntax --language dart examples/hello.dart
```

## Repository layout

```text
crates/hyena-cli       Command-line interface
crates/hyena-engine    Validated domain model and graph algorithms
crates/hyena-protocol  Experimental adapter protocol and framing
crates/hyena-syntax    Tree-sitter host and bundled language grammars
proto/                  Protobuf source schemas
docs/adr/               Architecture decision records
```

## Design principles

- Precision before finding count.
- Incomplete analysis is never equivalent to no findings.
- Source positions are zero-based, half-open UTF-8 byte spans internally.
- Symbol identities are opaque, scheme-versioned, and independent of source positions.
- Compiler-backed semantics and SCIP are preferred for dead-code evidence.
- Tree-sitter provides syntax facts, not semantic truth.
- Public adapters use supervised subprocesses rather than a native Rust ABI.
- Output and caches are deterministic; caches remain disposable.

## License

[MIT](LICENSE)
