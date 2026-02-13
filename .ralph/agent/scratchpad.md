# Phase 0: Baseline Lock

## Situation
- Branch: bun-1.3.8, build confirmed working as of 2026-02-13
- Formula: 2170 lines, enormous complexity
- `brew style` passes
- `brew audit --strict` fails because installed bun is 1.3.9 (from API) not our 1.3.8
- Many non-shipping artifacts on branch: .ralph*, logs/bun/*, ralph.yml, mise.toml, tools/bun_loop.sh, docs/bun-1.3.8-plan/*

## Phase 0 Plan
1. **Clean non-shipping artifacts** from git tracking (don't delete locally, just remove from commits)
2. **Run full baseline validation** from clean state (uninstall old, build from source, test, audit, style)
3. **Capture outputs and timing**
4. **Tag baseline commit**

## Current Task
Starting with workspace cleanup - identify all non-formula artifacts that should not be in the final PR.

## Key Non-Shipping Files
- `.ralph*/` - orchestration runtime
- `.ralph.bak.*/` - old backup
- `logs/bun/` - build log summaries
- `tools/bun_loop.sh` - loop detector script
- `ralph.yml` - orchestration config
- `mise.toml` - tool version manager config
- `docs/bun-1.3.8-plan/` - planning docs (useful locally, not for PR)
- `.gitignore` changes (may need to keep relevant parts)
