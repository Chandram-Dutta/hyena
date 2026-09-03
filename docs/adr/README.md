# Architecture decision records

Architecture decision records (ADRs) preserve decisions whose compatibility or correctness consequences would be expensive to rediscover.

| ADR | Decision | Status |
| --- | --- | --- |
| [0001](0001-core-and-frontends.md) | Separate the language-neutral core from language frontends | Accepted |
| [0002](0002-adapter-process-protocol.md) | Use bounded Protobuf frames over supervised subprocesses | Accepted for Phase 0 |
| [0003](0003-completeness-and-finding-certainty.md) | Gate finding certainty on explicit completeness | Accepted |

New ADRs should state context, decision, consequences, and alternatives. Supersede an ADR rather than rewriting the historical decision.
