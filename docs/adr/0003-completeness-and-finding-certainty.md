# ADR 0003: Gate finding certainty on explicit completeness

- **Status:** Accepted
- **Date:** 2026-09-03

## Context

Static-analysis inputs are often partial: packages fail to resolve, generated sources are missing, a frontend lacks reflection modeling, an adapter is cancelled, or only syntax facts are available. Treating missing facts as an empty set creates confident false positives, especially for dead-code analysis.

## Decision

Capabilities and run completeness are separate, explicit data.

Every correctness-relevant dimension is reported as `complete`, `partial`, `unsupported`, `failed`, or `not_requested`. Missing capability never means an empty result. Findings carry certainty derived from the required dimensions:

- **Proven unused:** the relevant analysis universe is closed and complete, and no retention path exists.
- **Candidate unused:** no use was observed, but relevant evidence is heuristic or partial.
- **Unknown:** unresolved behavior prevents a useful claim.

Only proven-unused findings may fail CI by default. Candidate mode must be explicitly requested and must not imply safe deletion.

The engine validates completeness before it labels findings; adapters do not assign final certainty themselves.

## Consequences

- Common environmental failures degrade confidence instead of silently creating findings.
- Every analysis must define the completeness dimensions it requires.
- Reports need diagnostics that explain why certainty was reduced.
- Some users will see fewer findings, but the remaining findings are defensible.

## Alternatives considered

- **Best-effort findings without confidence:** rejected because consumers cannot distinguish no use from missing evidence.
- **Binary success/failure:** rejected because one unsupported feature should not discard unrelated valid analysis.
- **Frontend-assigned severity:** rejected because policy must remain consistent across languages and report formats.
