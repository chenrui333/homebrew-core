# Bun v1.3.8 Formula Execution Contract

## Objective
Deliver a submission-ready Bun 1.3.8 Homebrew formula branch that is:
- reproducibly source-buildable,
- materially simpler than the current patch-heavy state,
- maintainable for future upgrades,
- backed by explicit validation gates.

Primary planning docs:
- `docs/bun-1.3.8-plan/master-roadmap.md`
- `docs/bun-1.3.8-plan/phase-checklists.md`
- `docs/bun-1.3.8-plan/upstream-issues-draft.md`

## Execution Mode
Work in **phase-gated mode** only.

Rules:
1. Execute exactly one phase at a time from `docs/bun-1.3.8-plan/phase-checklists.md`.
2. Do not begin the next phase until the current phase check-in gate is satisfied.
3. If a gate fails, stay in the same phase and iterate only on that phase scope.

## Commit Policy
1. One logical commit per coherent step.
2. Do not mix unrelated changes in the same commit.
3. Use commit messages that include phase context when applicable.
4. Avoid noisy intermediate commits once behavior is understood; prefer small, clean logical commits.

## Validation Policy
At each phase gate, run and report:
1. `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source Formula/b/bun.rb`
2. `brew test bun`
3. `brew audit --strict bun`
4. `brew style Formula/b/bun.rb`

If any command fails, document first failure and continue within current phase scope only.

## Patch Reduction Policy
During reduction phases:
1. For each removed/consolidated patch, record rationale:
   - keep / remove / consolidate
   - reason
   - risk level
2. Prefer deleting no-op and duplicate edits before touching ABI-sensitive edits.
3. Preserve behavior while reducing patch count and duplicated inreplace operations.

## Scope Guardrails
1. Keep edits focused on:
   - `Formula/b/bun.rb`
   - `tools/bun_loop.sh`
   - planning docs under `docs/bun-1.3.8-plan/`
2. Do not modify unrelated formulae.
3. Avoid broad refactors outside active phase goals.

## Artifact Policy
1. Do not commit `.ralph/*` runtime artifacts by default.
2. Commit `.ralph` artifacts only if explicitly requested.

## Network Policy
Allowed bootstrap activity:
- bootstrap bun download for codegen,
- bootstrap zig download when required.

Blocked activity:
- build-time `bun install` for external deps,
- build-time git clone/fetch for deps,
- arbitrary source/header fetches outside declared strategy.

## Reporting Format (per check-in)
- Active phase
- Changes made
- Validation results (install/test/audit/style)
- Patch count delta (if in reduction phase)
- Remaining risks / blockers

## Completion Marker
LOOP_COMPLETE
