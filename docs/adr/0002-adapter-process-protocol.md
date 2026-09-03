# ADR 0002: Use bounded Protobuf frames over supervised subprocesses

- **Status:** Accepted for Phase 0; data-plane schema remains experimental
- **Date:** 2026-09-03

## Context

Language frontends may need their native compiler runtime and can crash, hang, allocate excessively, or emit malformed data. A stable Rust dynamic-library ABI does not exist across independent toolchains. JSON is easy to inspect but expensive for large indexes and weakly governed unless a separate schema process is maintained.

## Decision

The public adapter boundary is a supervised subprocess. Transport uses a big-endian unsigned 32-bit frame length followed by a Protobuf envelope over stdin/stdout.

The core must enforce frame, byte, fact, time, and diagnostic limits; support cancellation; reject malformed messages; and treat stdout as protocol-only. The handshake negotiates major/minor protocol versions and named capabilities.

Package `hyena.adapter.v0` is a protocol spike, not a compatibility promise. Its minimal semantic fact data plane remains unfrozen until Dart and TypeScript vertical slices validate the fact model.

Protocol fields may be added compatibly, but field numbers are never reused, removed fields are reserved, enum zero values are unspecified, and unknown values are not interpreted as false.

## Consequences

- Frontends can use the compiler's native implementation language.
- A frontend crash does not corrupt core memory.
- The protocol can be captured and tested independently.
- Subprocess isolation is not a security sandbox; adapters remain trusted in Phase 0.
- Serialization and process startup add overhead, so facts must be streamed in bounded batches.

## Alternatives considered

- **Rust dynamic libraries:** rejected due to ABI and shared-failure-domain risks.
- **JSON-RPC/LSP:** rejected as the canonical high-volume transport; LSP can still back a frontend.
- **Wasm/WASI:** deferred because compiler frontends may need threads, subprocesses, and host toolchains.
- **In-process language runtimes:** rejected as a universal boundary because each runtime would expand core complexity and failure exposure.
