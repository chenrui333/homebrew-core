# Bun v1.3.8 Source-Build Orchestration

## Objective
Iterate on a Homebrew/core **source build** of Bun v1.3.8 with constraints:
- **Bootstrap binary allowed** (like Rust/Go - bun needs bun for codegen)
- No build-time git clones or `bun install` for external deps.
- Prefer system/Homebrew deps where available.
- Vendor small deps as resources when system versions unavailable.

## Bootstrap Philosophy
Like `rustc` (needs rustc to build) and `go` (needs go to build), Bun requires
a working bun binary to generate codegen files (`ZigGeneratedClasses.zig`, etc.).
This is an accepted pattern for self-hosting compilers/runtimes.

## Loop
On each iteration:
1. Run the loop script:
   - `tools/bun_loop.sh`
2. Read the latest summary:
   - `logs/bun/summary-*.txt` (most recent timestamp)
3. If summary contains `SUCCESS`:
   - Mark `- [x] TASK_COMPLETE` below and stop.
4. If summary contains `NETWORK_ACTIVITY_DETECTED` for non-bootstrap downloads:
   - Identify the exact trigger (file path + command).
   - Add a minimal fail-fast guard or a `USE_SYSTEM_*` switch to prevent downloads.
   - Prefer CMake options over large refactors.
5. If summary contains a compile or configure error:
   - Patch the minimal CMake or source file to resolve the **first** failure only.
   - Do not preemptively fix unrelated issues.
6. Commit after each iteration:
   - `git add` changed files
   - `git commit -m "bun: prototype <short change>"`

## Allowed Network Activity (Bootstrap)
The following are acceptable during build:
- Bootstrap bun binary download (for codegen)
- Bootstrap zig download (if USE_SYSTEM_ZIG doesn't work)

## Blocked Network Activity
The following should be prevented:
- npm/bun install for JS dependencies
- git clone for C/C++ dependencies
- Arbitrary URL fetches for headers/sources

## Guardrails
- Keep diffs minimal and surgical.
- Do not add Homebrew allowlists or large resource closures.
- Do not modify unrelated formulae.
- Keep patches in `Formula/b/bun.rb` unless absolutely necessary elsewhere.

## Files of Interest
- Formula: `Formula/b/bun.rb`
- Status doc: `docs/bun-1.3.8-status.md`
- Loop script: `tools/bun_loop.sh`

## Progress So Far
Successfully patched/vendored:
- ✅ System zig support (USE_SYSTEM_ZIG=ON)
- ✅ System deps: brotli, c-ares, highway, libdeflate, lol-html, mimalloc, zlib, zstd, libarchive, hdrhistogram_c, libuv, sqlite, boringssl
- ✅ Vendored: picohttpparser, ls-hpack, nodejs-headers
- ✅ Zig 0.15.x compatibility (@hasField guard for no_link_obj)
- ✅ CMake 4 policy for lshpack
- ✅ esbuild external peechy/preact patches
- ✅ Bootstrap re-enabled for codegen

## Stop Conditions
Stop and report if any of the following remain unavoidable without upstream changes:
- Zig download is hard-coded AND USE_SYSTEM_ZIG is broken.
- Dependencies are only available via git-clone at build time (not vendorable).
- WebKit cannot be built locally with the expected headers/derived sources.

## Completion Marker
LOOP_COMPLETE
