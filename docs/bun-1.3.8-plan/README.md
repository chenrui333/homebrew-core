# Bun 1.3.8 Homebrew Formula Stabilization Plan

This folder contains a multi-phase plan to move the current `bun-1.3.8` branch from
"build passes" to "submission-ready, maintainable formula".

## Documents

- `master-roadmap.md`: high-level strategy, principles, risks, and sequencing.
- `phase-checklists.md`: detailed per-phase tasks, validation commands, and check-in criteria.
- `upstream-issues-draft.md`: issue templates and batching strategy for upstream reports.

## Operating Rules

1. Keep one active phase at a time.
2. Do not mix patch-reduction with feature changes.
3. Every phase must end with a reproducible validation run.
4. Only merge to PR branch after passing the phase "check-in gate".

## Quick Status Template

Use this in commit messages / notes:

- Phase: `<P#>`
- Scope: `<what changed>`
- Validation: `install/test/audit/style` results
- Remaining risk: `<known risks>`
