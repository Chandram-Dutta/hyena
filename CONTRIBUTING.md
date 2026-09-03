# Contributing

Hyena is in an early contract-validation phase. Please discuss substantial language, protocol, or storage work before implementation so the project does not freeze one language's assumptions into shared APIs.

## Development checks

```bash
cargo fmt --all -- --check
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo test --workspace --all-targets --all-features --locked
```

Changes to protocol fields, semantic meanings, source coordinates, symbol identity, completeness, finding fingerprints, or metric algorithms require an architecture decision record under `docs/adr/`.

Protocol compatibility rules:

- never renumber or reuse a Protobuf field;
- reserve removed field numbers and names;
- use `UNSPECIFIED = 0` for enums;
- treat unknown fields, capabilities, and enum values as unknown rather than false;
- do not describe `hyena.adapter.v0` as stable.

Language frontends must report unsupported and partial capabilities explicitly. A frontend may not claim `proven unused` when required semantic dimensions are incomplete.
