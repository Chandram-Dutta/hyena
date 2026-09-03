# Initial technical proposal

- **Status:** Draft for validation
- **Protocol status:** Experimental v0
- **Scope:** A new repository, independent of `hyena_dart`

## Summary

Hyena should be a local-first, multi-language static-analysis engine with a fast Rust core and language-specific frontends. It should normalize a small set of evidence-bearing facts instead of attempting to define a universal AST.

The core will orchestrate frontends, validate facts, construct derived graphs, run analysis, cache immutable fragments, and report deterministic findings. Tree-sitter supplies broadly available syntax facts. Compiler APIs and SCIP-backed frontends supply semantic identities and references.

The central conclusion is:

> A universal analysis engine is practical; a universal semantic frontend is not.

## Goals

1. Analyze polyglot repositories through one CLI and result model.
2. Produce high-confidence dead-code findings using compiler-grade semantics where available.
3. Compute fast, explicitly versioned complexity metrics.
4. Preserve evidence, frontend provenance, project variants, and completeness.
5. Support incremental local and CI analysis without making caches authoritative.
6. Provide a language-independent adapter protocol and conformance suite.
7. Fail safely on malformed source, adapter failures, and resource exhaustion.

## Non-goals for v1

- A universal type checker or compiler.
- A full CodeQL/Joern query platform.
- Security taint analysis or symbolic execution.
- Automatic execution of project build scripts or untrusted plugins.
- Perfect cross-language linking without explicit bridge evidence.
- A stable native dynamic-library plugin ABI.
- A distributed graph database or hosted indexing service.

## Architecture

```text
source tree
    │
    ├──▶ Tree-sitter language pack ──▶ syntax facts
    │
    └──▶ compiler/SCIP frontend ─────▶ semantic facts
                                         │
                                         ▼
                              validated immutable fragments
                                         │
                              ┌──────────┴──────────┐
                              ▼                     ▼
                     retention overlay       complexity profile
                              │                     │
                              └──────────┬──────────┘
                                         ▼
                              deterministic findings
```

### Core responsibilities

- Validate root-confined paths and canonical artifact identities.
- Supervise adapter processes with bounded I/O and deadlines.
- Verify syntax and semantic fragments refer to identical source digests and variants.
- Assign deterministic run-local IDs and construct compact adjacency structures.
- Compute reachability and common metrics.
- Gate finding certainty on declared capabilities and per-run completeness.
- Own fingerprints, baselines, JSON, SARIF, and explanations.

### Frontend responsibilities

- Discover projects, compilation units, package identities, and variants.
- Resolve declarations, definitions, references, calls, exports, and visibility.
- Represent dispatch candidates, generated code, reflection, and FFI honestly.
- Emit roots and language-aware retention edges with evidence.
- Emit precise CFG facts when supported.
- Report unresolved and unsupported behavior rather than omitting it.

## Domain invariants

### Artifacts and spans

- Portable paths are project-relative, `/`-separated, case-preserving, and contain no empty, `.` or `..` components.
- Physical host paths are execution details and never stable artifact identities.
- Every artifact includes its exact content digest and source encoding.
- Canonical spans are zero-based half-open byte ranges: `[start_byte, end_byte)`.
- LSP/SCIP positions declare UTF-8, UTF-16, or UTF-32 code-unit encoding and are converted at ingress.
- Facts from independent producers merge only when artifact digest and project variant agree.

### Symbols and occurrences

- Symbol keys are opaque `{scheme, scheme_version, value, stability}` tuples.
- Cross-snapshot keys derive from semantic ownership/signature, never source line or encounter order.
- Global, file-private, local, anonymous, generated, and specialized symbols have distinct identity guarantees.
- An occurrence can be a declaration, definition, reference, call, read, write, import, export, address-taking, type use, generated use, or several at once.
- A reference is not automatically a call; absent resolution is not an absent occurrence.
- Multiple declarations or definitions of one symbol are valid.

### Relations, retention, and roots

Base relations represent contains, references, calls, imports, exports, aliases, inheritance, implementation, overrides, instantiation, capture, registration, generation, and type relations.

Dead-code reachability runs over a separate language-aware retention overlay. This avoids universal but unsound rules such as treating every reference as runtime reachability or every override as live.

Roots are explicit, evidence-bearing facts: executable entry points, public APIs, linker-preserved symbols, framework registrations, reflection manifests, serialization hooks, FFI boundaries, generated registries, tests, and user keep rules.

### Capabilities and completeness

A capability describes what a frontend implements. Completeness describes whether that information was successfully produced for this snapshot. Each dimension is:

```text
complete | partial | unsupported | failed | not_requested
```

Missing capability is never equivalent to an empty fact set.

### Finding certainty

Dead-code outcomes are:

1. **Proven unused** — complete closed analysis universe and no retention path.
2. **Candidate unused** — no observed use, but at least one relevant dimension is heuristic or partial.
3. **Unknown** — unresolved behavior prevents a useful claim.

Only proven-unused findings should fail CI by default. Candidate mode must be explicit and must not claim deletion safety.

### Complexity

CFG-based cyclomatic complexity and syntax decision count are different algorithms. Every metric carries an immutable algorithm ID/version and the policy defining exception edges, short-circuit branches, switch/match behavior, async behavior, and generated cleanup. Values from different profiles are not automatically comparable.

## Adapter boundary

Use supervised subprocesses, not native Rust dynamic libraries. Rust has no stable independent plugin ABI, and in-process plugins share the core's crash and memory domain.

The Phase 0 transport is a big-endian `u32` frame length followed by a Protobuf envelope on stdin/stdout. Stdout is protocol-only; stderr is bounded diagnostics. The core enforces frame, byte, fact, time, and process limits.

The initial handshake negotiates protocol version and named capabilities. V0 intentionally defines only the control plane. The semantic fact data plane will be encoded only after Dart and TypeScript vertical slices validate the core model.

Protocol evolution rules:

- major versions may alter meaning or remove guarantees;
- minor versions only add compatible optional data;
- field numbers are never reused;
- removed fields are reserved;
- enum zero values are unspecified;
- unknown data is not interpreted as false;
- metric and symbol schemes evolve under independent version identifiers.

Wasm/WASI may later host downloadable untrusted adapters. It is not the v1 boundary because real compiler frontends may need threads, subprocesses, and toolchain access that do not map cleanly to WASI.

## SCIP and Tree-sitter

SCIP is accepted as an interchange source for canonical documents, package-qualified symbols, definitions, references, symbol kinds, and some implementation relationships. It is not Hyena's internal IR because it does not standardize roots, visibility/export graphs, calls, dynamic dispatch, reflection, FFI retention, variants, CFGs, or completeness.

Tree-sitter provides fast parser trees and queryable syntax across many languages. It supports function discovery and syntax complexity but not compiler-grade semantic references. Tree-sitter-only dead-code findings are therefore heuristic candidates, never proven-unused findings.

## Cross-language links

The engine never links symbols by display-name matching. Cross-language edges require explicit evidence such as FFI linkage, generated binding metadata, RPC/schema identity, framework manifests, compiler/linker metadata, or user bridge declarations. Unresolved externally visible endpoints remain conservative boundary roots.

## Performance and storage

- Parallelize immutable file-local syntax work and merge in stable path order.
- Use stable symbol keys externally and dense `u32` IDs internally.
- Store typed edges in sorted vectors and CSR-like adjacency snapshots.
- Do not persist full syntax trees by default.
- Stream adapter batches and SCIP documents with pre-allocation limits.
- Use a private, disposable SQLite cache keyed by content, toolchain, adapter, grammar, variant, dependency, and configuration digests after vertical-slice benchmarks justify persistence.
- Modification time may accelerate checks but is never the correctness boundary.

## Validation gates

Protocol 1.0 must not be published until:

1. A Dart analyzer-backed frontend reproduces or deliberately improves the existing Hyena fixture behavior.
2. A TypeScript compiler/SCIP frontend exercises overloads, exports, callbacks, and project variants.
3. An independently produced SCIP corpus is imported successfully.
4. The model is reviewed against Python dynamics, Rust macros/traits, and C++ overload/templates/conditional compilation.
5. Position, identity, determinism, cancellation, malformed input, and old/new protocol conformance suites pass.

## Delivery phases

### Phase 0 — feasibility and contract spike

- Rust workspace and CLI.
- Validated domain types and deterministic reachability.
- Experimental bounded Protobuf handshake.
- Dart and TypeScript Tree-sitter fixtures.
- Streaming SCIP experiment.
- Benchmark harness and threat model.

### Phase 1 — Dart vertical slice

- Dart analyzer adapter.
- Symbols, occurrences, roots, retention, complexity, and SARIF.
- Differential testing against `hyena_dart`.

### Phase 2 — TypeScript vertical slice

- TypeScript compiler or SCIP adapter.
- Cross-language contract revisions.
- Deterministic incremental cache.

### Phase 3 — protocol candidate

- Generated adapter SDKs.
- Compatibility and conformance tooling.
- Third-language semantic review.
- Security review of path, protocol, and process boundaries.

### Phase 4 — production release

- Signed cross-platform binaries, checksums, SBOM, and provenance.
- Official adapter installation/trust model.
- Measured performance budgets and regression CI.

## Primary references

- [SCIP schema](https://github.com/scip-code/scip/blob/main/scip.proto)
- [Glean architecture](https://glean.software/docs/introduction/)
- [Joern Code Property Graph](https://docs.joern.io/code-property-graph/)
- [Kythe overview](https://kythe.io/docs/kythe-overview.html)
- [CodeQL overview](https://codeql.github.com/docs/codeql-overview/about-codeql/)
- [Tree-sitter](https://tree-sitter.github.io/)
- [Protocol Buffers compatibility](https://protobuf.dev/programming-guides/proto3/)
- [LSP 3.17](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/)
- [SARIF 2.1.0](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html)
- [McCabe's complexity paper](https://doi.org/10.1109/TSE.1976.233837)
