# Hyena

Hyena is an experimental, local-first engine for fast and reliable static analysis across programming languages.

The project is in **Phase 0**. It currently provides:

- a Rust workspace with a validated semantic identity and retention-graph model;
- deterministic reachability analysis that refuses to claim proven dead code from incomplete inputs;
- an experimental, bounded Protobuf protocol and supervised adapter host;
- a Dart analyzer-backed semantic adapter vertical slice;
- a Tree-sitter syntax host with initial Dart grammar integration;
- an early `hyena` CLI for semantic analysis and syntax inspection.

Dead-code output is still experimental. The Dart adapter reports framework/reflection roots and dynamic behavior as partial, so the default command refuses to claim proven-unused code. Candidate findings require an explicit flag. Protocol package `hyena.adapter.v0` remains unstable until Dart and TypeScript vertical slices validate the contract.

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

The repository pins Rust 1.98.0 and Dart 3.10.3. On an Amp orb, `.agents/setup` installs both toolchains and builds the engine and adapter. Elsewhere, install [rustup](https://rustup.rs/) and the [Dart SDK](https://dart.dev/get-dart), then run:

```bash
cargo build --workspace --all-targets --locked
cargo test --workspace --all-targets --all-features --locked
cargo clippy --workspace --all-targets --all-features -- -D warnings
cd adapters/dart && dart pub get && dart test
```

Try the current CLI surface:

```bash
cargo run -p hyena-cli -- doctor
cargo run -p hyena-cli -- syntax --language dart examples/hello.dart
cargo run -p hyena-cli -- analyze test/fixtures/dart/basic --include-candidates
```

The setup script compiles the reference adapter to `target/hyena-dart-adapter`, which is the CLI's development default. Without `--include-candidates`, analysis fails closed while required completeness dimensions are partial.

## Repository layout

```text
crates/hyena-cli       Command-line interface
crates/hyena-adapter-host  Subprocess supervision and fact validation
crates/hyena-engine    Validated domain model and graph algorithms
crates/hyena-protocol  Experimental adapter protocol and framing
crates/hyena-syntax    Tree-sitter host and bundled language grammars
adapters/dart/          Dart analyzer-backed semantic frontend
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
