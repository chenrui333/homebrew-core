# Bun v1.3.8 Source-Build Orchestration

## Objective
Iterate on a Homebrew/core **source build** of Bun v1.3.8 with strict constraints:
- No bootstrap bun/zig/webkit binaries.
- No build-time downloads / git clones / `bun install`.
- Prefer system/Homebrew deps.
- No “resource everything.”

## Loop
On each iteration:
1. Run the loop script:
   - `tools/bun_loop.sh`
2. Read the latest summary:
   - `logs/bun/summary-*.txt` (most recent timestamp)
3. If summary contains `SUCCESS`:
   - Mark `- [x] TASK_COMPLETE` below and stop.
4. If summary contains `NETWORK_ACTIVITY_DETECTED`:
   - Identify the exact trigger (file path + command).
   - Add a minimal fail-fast guard or a `USE_SYSTEM_*` switch to prevent downloads.
   - Prefer CMake options over large refactors.
5. If summary contains a compile or configure error:
   - Patch the minimal CMake or source file to resolve the **first** failure only.
   - Do not preemptively fix unrelated issues.
6. Commit after each iteration:
   - `git add` changed files
   - `git commit -m "bun: prototype <short change>"`

## Guardrails
- Keep diffs minimal and surgical.
- Do not add Homebrew allowlists or large resource closures.
- Do not modify unrelated formulae.
- Keep patches in `Formula/b/bun.rb` unless absolutely necessary elsewhere.

## Files of Interest
- Formula: `Formula/b/bun.rb`
- Status doc: `docs/bun-1.3.8-status.md`
- Loop script: `tools/bun_loop.sh`

## Stop Conditions
Stop and report if any of the following remain unavoidable without upstream changes:
- Codegen requires bun with no alternative generator.
- Zig download is hard-coded.
- Dependencies are only available via git-clone at build time.
- WebKit cannot be built locally with the expected headers/derived sources.

## Completion Marker
LOOP_COMPLETE
