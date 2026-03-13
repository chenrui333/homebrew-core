# Bun v1.3.8 Experimental Simplification Contract

## Context
This branch is an **experiment branch**, not the final Homebrew/core PR branch.

- Goal now: simplify `Formula/b/bun.rb` with best effort while keeping it buildable.
- Final PR prep (branch split, commit cleanup, artifact cleanup) happens later on a separate branch.

## Primary Objective
Iteratively reduce complexity in `Formula/b/bun.rb` while preserving successful source build behavior.

Success criteria for each iteration:
1. net simplification (fewer or clearer patches), and
2. no regression in baseline checks used for the change.

## Operating Mode
Work in phase-guided mode using:
- `docs/bun-1.3.8-plan/master-roadmap.md`
- `docs/bun-1.3.8-plan/phase-checklists.md`
- `docs/bun-1.3.8-plan/upstream-issues-draft.md`

If phase gates are too strict for exploratory work, continue in the same phase and record why.

## Commit Policy (Experimental)
1. Preserve full history (do **not** squash or rewrite this branch history).
2. Commit frequently with small logical deltas.
3. Include rationale in commit messages for patch removals/consolidations.
4. Do not optimize for PR-perfect history yet.

## Artifact Policy (Experimental)
Preserve artifacts and history on this branch:
- keep `.ralph/*` artifacts,
- keep planning and loop artifacts,
- keep investigation breadcrumbs useful for later PR authoring.

Do not perform artifact cleanup in this branch unless explicitly requested.
Do not remove/untrack non-shipping artifacts from this branch (including
`.ralph/**`, `.ralph.bak*/**`, `logs/**`, `tools/**`, `docs/**`,
`PROMPT.md`, `.gitignore`, `ralph.yml`, `mise.toml`) unless explicitly requested.

## Scope Guardrails
1. Prioritize edits in `Formula/b/bun.rb`.
2. Allow support edits in `tools/bun_loop.sh` and planning docs when needed.
3. Do not modify unrelated formulae.

## Validation Policy
Use pragmatic validation per change size:

- Small/local simplification: run at least relevant subset (`style`, targeted build step if possible).
- Medium/large simplification: run full gate sequence:
  1. `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source Formula/b/bun.rb`
  2. `brew test bun`
  3. `brew audit --strict bun`
  4. `brew style Formula/b/bun.rb`

Record what was run and what was intentionally deferred.

## Network Policy
Allowed bootstrap activity:
- bootstrap bun download for codegen,
- bootstrap zig download when required.

Blocked activity remains:
- build-time `bun install` for external deps,
- build-time git clone/fetch for deps,
- arbitrary source/header fetches outside declared strategy.

## Reporting Format (per check-in)
- Active phase / workstream
- Simplification performed
- Patch count or complexity delta
- Validation run and result
- Remaining risks / next candidates

## Completion Marker
LOOP_COMPLETE
