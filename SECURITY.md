# Security policy

## Reporting a vulnerability

Please use GitHub's private vulnerability reporting for this repository. Do not include exploit details or sensitive source code in a public issue.

## Current support status

Hyena is pre-1.0 experimental software. Security fixes target the latest commit on the default branch.

Target source, paths, archives, compiler metadata, and adapter output are treated as untrusted. However, Phase 0 language adapters are trusted subprocesses: process isolation limits crashes but is not a security sandbox. Do not install or run an adapter you do not trust.
