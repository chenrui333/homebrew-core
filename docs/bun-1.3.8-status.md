# Bun v1.3.8 Source-Build Feasibility Status

## Objective
Attempt a Homebrew/core source build of Bun v1.3.8 with **no bootstrap binaries**, **no build-time downloads**, and **no “resource everything”**. The current prototype still allows downloads to surface failure points quickly; final goal is a policy-compliant, offline build.

## Constraints
- No bootstrap bun/zig/webkit binaries.
- No build-time network activity (downloads, git clones, bun install).
- Prefer system/Homebrew deps where possible.
- Avoid large vendored resource closures.

## Local Environment
- Bun source checkout: `/Users/rchen/Downloads/brew/bun` (tag `bun-v1.3.8`)
- homebrew-core checkout: `/opt/homebrew/Homebrew/Library/Taps/homebrew/homebrew-core` (branch `bun-1.3.8`)
- Prototype formula: `Formula/b/bun.rb`
- WebKit checkout: `/Users/rchen/Downloads/brew/bun-WebKit` (commit `autobuild-9a2cc42ae1bf693a0fd0ceb9b1d7d965d9cfd3ea`)

## Repro Steps (Recent)
1. Build from source (prototype, downloads allowed):
   - `cd /opt/homebrew/Homebrew/Library/Taps/homebrew/homebrew-core`
   - `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source ./Formula/b/bun.rb -v 2>&1 | tee /tmp/bun-build.log`
2. WebKit attempts (local build):
   - `cd /Users/rchen/Downloads/brew/bun-WebKit`
   - `Tools/Scripts/build-webkit --cmake --release --cmakeargs="-DCMAKE_BUILD_TYPE=Release" 2>&1 | tee /tmp/webkit-cmake-build.log`

## Evidence-Backed Blockers (Upstream v1.3.8)
These are based on the **unpatched v1.3.8 tarball** in Homebrew cache:
`/Users/rchen/Library/Caches/Homebrew/downloads/5893d56c4d1ab1cbd456077a3a5863c0618e4649e194100eec5a1cd3946ae391--bun-bun-v1.3.8.tar.gz`

1. **Requires a preinstalled bun**
   - File: `cmake/tools/SetupBun.cmake`
   - Evidence: uses `find_command` to locate `bun` and configures `BUN_EXECUTABLE` unconditionally.
     - Excerpt:
       - `find_command( VARIABLE BUN_EXECUTABLE COMMAND bun ... )`
       - `set(BUN_EXECUTABLE ${BUN_EXECUTABLE} CACHE FILEPATH "Bun executable" FORCE)`

2. **Downloads Zig at build time**
   - File: `cmake/tools/SetupZig.cmake`
   - Evidence: `register_command` runs `DownloadZig.cmake` to fetch Zig into `vendor/zig`.
     - Excerpt:
       - `COMMENT "Downloading zig"`
       - `-P ${CWD}/cmake/scripts/DownloadZig.cmake`

3. **Build-time git clones of deps**
   - File: `cmake/Globals.cmake`
   - Evidence: `register_repository` invokes `GitClone.cmake` to clone repositories into `vendor/`.
     - Excerpt:
       - `register_command(... -P ${CWD}/cmake/scripts/GitClone.cmake ...)`

4. **Build-time `bun install`**
   - File: `cmake/tools/SetupEsbuild.cmake`
   - Evidence: runs `bun install --frozen-lockfile` to populate `node_modules`.
     - Excerpt:
       - `COMMAND ${BUN_EXECUTABLE} install --frozen-lockfile`

5. **WebKit download unless WEBKIT_LOCAL**
   - File: `cmake/tools/SetupWebKit.cmake`
   - Evidence: sets `WEBKIT_DOWNLOAD_URL` and uses cached tarball unless `WEBKIT_LOCAL`.
     - Excerpt:
       - `setx(WEBKIT_DOWNLOAD_URL https://github.com/oven-sh/WebKit/releases/download/... )`

## WebKit Effort Status
- **Target commit:** `9a2cc42ae1bf693a0fd0ceb9b1d7d965d9cfd3ea` (from `SetupWebKit.cmake` default).
- **Local checkout:** `/Users/rchen/Downloads/brew/bun-WebKit` (autobuild tag).
- **CMake build attempt failed** due to missing sources/derived files.
  - Evidence: `/tmp/webkit-cmake-build.log` reports missing files like `bmalloc/IsoHeap.cpp`, `cocoa/RuntimeApplicationChecksCocoa.cpp`, and missing derived sources.
- **Local layout mismatch risk:** Bun’s `SetupWebKit.cmake` expects headers under:
  - `${WEBKIT_PATH}/JavaScriptCore/Headers`, `${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders`, etc.
  - In the current local build tree, `WebKitBuild/Release/JavaScriptCore/Headers` is missing.
- **Implication:** If WebKit headers/derived sources aren’t produced in the expected layout, Bun’s bindings may not match the WebKit build, resulting in class/ABI mismatches.

## Current Build State (Prototype, downloads allowed)
- Latest loop run log: `logs/bun/build-20260207-045240.log` (2026-02-07).
- The first actionable blocker is still **network activity during configure/build**:
  - Line `9`: bootstrap bun archive download via `curl ... bun-bootstrap.zip`.
  - Line `102`: `WEBKIT_DOWNLOAD_URL` points at a remote WebKit tarball.
  - Lines `366+`: repeated `GitClone.cmake` invocations for vendored deps.
  - Line `1437`: build step `Downloading zig`.
  - Line `1438`: `DownloadZig.cmake` invocation.
- This confirms the loop should keep prioritizing **fail-fast/no-download switches** before pure compile-failure fixes.

## Next Steps (Prioritized)
1. **Local WebKit build that matches Bun’s expectations**
   - Produce `${WEBKIT_PATH}/JavaScriptCore/Headers` and required `cmakeconfig.h` + derived sources.
   - Validate headers and libs match Bun’s include paths.
2. **System Zig support (no download)**
   - Add `USE_SYSTEM_ZIG` option to `SetupZig.cmake` (prototype patch already exists in formula).
3. **Disable git-clone deps**
   - Add `USE_SYSTEM_*` options for dependencies now cloned via `register_repository`.
4. **Bootstrap removal / codegen strategy**
   - Either ship pre-generated codegen outputs in release tarball or add a Node-based generator.

## Stop Conditions (Upstream Changes Required)
Stop and file upstream issues if any of these remain true after targeted patches:
- **Codegen requires bun** with no supported non-bun generator.
- **Zig download is hard-coded** with no system-compiler mode.
- **Core dependencies are only available via git-clone** at build time.
- **WebKit build cannot produce Bun-compatible headers/derived sources** at the pinned commit.
