# Memories

## Patterns

## Decisions

## Fixes

### mem-1770844889-09cc
> bun bootstrap-off: inject -DCMAKE_POLICY_VERSION_MINIMUM=3.5 into BuildLshpack register_cmake_command args via formula inreplace; lshpack config/build now succeeds under CMake 4 and first blocker moves to zig build no_link_obj API mismatch
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770844718-a5c4
> bun bootstrap-off: patch BuildBun bun-error esbuild command via formula inreplace to externalize preact, preact/hooks, and preact/jsx-runtime; bun-error codegen now succeeds and first blocker moves to downstream lshpack CMake policy / zig build issues
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770844615-29fd
> failure: cmd=brew style Formula/b/bun.rb and brew audit --strict bun after bun_error_esbuild_cmd refactor, exit=1, error='redundant string escapes and remaining line-continuation indentation in replacement string', next=use plain " escapes only where needed and build replacement via multiline interpolation without backslash continuations
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770844508-6f15
> failure: cmd=brew style Formula/b/bun.rb and brew audit --strict bun after bun-error preact patch, exit=1, error='Layout/LineContinuationLeadingSpace offenses in inreplace multiline string', next=rewrite replacement using local multiline variable instead of backslash line continuations
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770844433-0fa5
> failure: cmd=HOMEBREW_BUN_LOCK_WAIT_SECS=0 tools/bun_loop.sh after strict bun-error inreplace block, exit=1, error='inreplace failed expected replacement in cmake/targets/BuildBun.cmake due whitespace/context mismatch', next=use regex-anchored inreplace on bun-error command segment instead of exact multiline block
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770844269-f858
> failure: cmd=ls -1t logs/bun/run-*.log | head -n 1, exit=1, error='zsh no matches found for run-*.log', next=use summary files and Homebrew build log instead of assuming run log naming
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770844269-be28
> bun bootstrap-off: patch BuildBun fallback-decoder esbuild invocation to add --external:peechy via formula inreplace; build advances past fallback.ts missing peechy and next blocker becomes bun-error missing preact
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770844044-d4d6
> failure: cmd=rg -n 'Using system esbuild|node_modules/.bin/esbuild|FAILED: \[code=1\] lshpack|Could not resolve "preact"|Download node 24.3.0 headers|NETWORK_ACTIVITY_DETECTED|SUCCESS' <latest summary>, exit=1, error='no matches in filtered summary', next=inspect full bun loop output/logs directly to confirm blocker movement
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770844044-7544
> bun bootstrap-off: add USE_SYSTEM_ESBUILD in SetupEsbuild.cmake via formula inreplace, depend on esbuild, and set -DUSE_SYSTEM_ESBUILD=ON; build now uses /opt/homebrew/bin/esbuild and advances past missing node_modules/.bin/esbuild
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770843721-df38
> bun bootstrap-off: patch SetupZig.cmake in formula inreplace so USE_SYSTEM_ZIG returns before clone-zig download command, unsets ZIG_EXECUTABLE normal/cache, and resolves /opt/homebrew/bin/zig from PATH; first blocker advances to missing node_modules/.bin/esbuild
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770843248-7bfe
> failure: cmd=tar -xOf <bun-tarball> bun-bun-1.3.8/cmake/tools/SetupBun.cmake, exit=1, error='path not found in archive', next=use correct root path bun-bun-v1.3.8 when extracting files from cache tarball
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770843009-c741
> failure: cmd=cat <<EOF >> .ralph/agent/scratchpad.md with escaped backtick payload, exit=1, error=unified exec rejected input due nul byte in command data, next=append scratchpad using plain quoted heredoc without escaped control sequences
<!-- tags: tooling, error-handling | created: 2026-02-11 -->

### mem-1770842088-9363
> bun bootstrap-off: set -DENABLE_TINYCC=OFF in Formula/b/bun.rb to bypass BuildTinyCC register_repository download path; configure now completes and first blocker moves to build-phase network/codegen issues (esbuild missing, DownloadZig)
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770841990-d92b
> failure: cmd=apply_patch for bun cmake args adding -DENABLE_TINYCC=OFF, exit=1, error=expected hunk context not found in Formula/b/bun.rb args block, next=inspect current args section and patch with exact context
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770841959-6c3a
> failure: cmd=ls -1t ~/Library/Caches/Homebrew/downloads/*bun-bun-v1.3.8.tar.gz | head -n 1 | xargs ... tar -xOf ..., exit=1, error=xargs command line cannot be assembled, too long, next=extract BuildTinyCC.cmake by assigning cache tar path in shell variable and avoid xargs
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770841792-8e2a
> failure: cmd=tools/bun_loop.sh, exit=1, error=timed out waiting for active brew process after 120s lock wait, next=rerun loop once lock clears to capture real first Bun blocker
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770841622-1e1b
> bun bootstrap-off: add USE_SYSTEM_HDRHISTOGRAM path in BuildHdrHistogram.cmake via formula inreplace, depend on hdrhistogram_c, and set -DUSE_SYSTEM_HDRHISTOGRAM=ON; configure logs 'Using system hdrhistogram_c' and advances first blocker from BuildHdrHistogram to BuildTinyCC
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770841168-114c
> bun bootstrap-off: add USE_SYSTEM_LIBARCHIVE path in BuildLibArchive.cmake via formula inreplace, depend on libarchive, and set -DUSE_SYSTEM_LIBARCHIVE=ON; configure logs 'Using system libarchive' and advances first blocker from BuildLibArchive to BuildHdrHistogram
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770840709-b554
> failure: cmd=cat >> .ralph/agent/scratchpad.md <<EOF with backticked content, exit=127, error='zsh executed backticks (command not found/permission denied)', next=append scratchpad using quoted heredoc or no backticks
<!-- tags: tooling, error-handling | created: 2026-02-11 -->

### mem-1770840671-eacb
> bun bootstrap-off: add USE_SYSTEM_ZLIB path in BuildZlib.cmake via formula inreplace and set -DUSE_SYSTEM_ZLIB=ON; configure logs 'Using system zlib' and advances first blocker from BuildZlib to BuildLibArchive
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770840666-827c
> failure: cmd=rg -n 'Using system zlib|BuildLibArchive|CMake Error|SUCCESS|NETWORK_ACTIVITY_DETECTED' <latest-summary>, exit=1, error='no matches in filtered summary', next=inspect full loop output and summary directly to confirm blocker movement
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770840231-65d2
> bun bootstrap-off: add USE_SYSTEM_MIMALLOC path in BuildMimalloc.cmake via formula inreplace, depend on Homebrew mimalloc, and set -DUSE_SYSTEM_MIMALLOC=ON; configure advances from BuildMimalloc to BuildZlib
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770839800-e7bc
> bun bootstrap-off: vendor ls-hpack as formula resource and gate BuildLshpack register_repository on local vendor/lshpack/CMakeLists.txt; configure advances from BuildLshpack to BuildMimalloc without lshpack git clone
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770839312-38ca
> bun bootstrap-off: add USE_SYSTEM_LOLHTML path in BuildLolHtml.cmake via formula inreplace, link bun with pkg-config target PkgConfig::LOLHTML from lol-html dependency, and set -DUSE_SYSTEM_LOLHTML=ON; configure advances from BuildLolHtml to BuildLshpack
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770839288-d6c4
> failure: cmd=rg -n 'Using system lol-html|BuildLshpack|CMake Error|NETWORK_ACTIVITY_DETECTED|SUCCESS' <latest-summary>, exit=1, error='no matches in filtered summary', next=inspect summary directly and cross-check Homebrew build log text
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770838858-bebc
> failure: cmd=tools/bun_loop.sh, exit=1, error=after USE_SYSTEM_LIBDEFLATE activation first blocker moved to BuildLolHtml.cmake under register_repository download guard, next=add minimal USE_SYSTEM_LOLHTML path in Formula/b/bun.rb
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770838425-a597
> failure: cmd=tools/bun_loop.sh, exit=1, error=after USE_SYSTEM_HIGHWAY activation first blocker moved to BuildLibDeflate.cmake under register_repository download guard, next=add minimal USE_SYSTEM_LIBDEFLATE path in Formula/b/bun.rb
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770838005-d754
> failure: cmd=tools/bun_loop.sh, exit=1, error=next first blocker is BuildHighway.cmake under register_repository download guard after system c-ares activation, next=future iteration should add minimal USE_SYSTEM_HIGHWAY or equivalent guard
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770837827-f78b
> failure: cmd=rg -n 'BuildCares|c-ares|cares' ...bun-v1.3.8.tar.gz, exit=1, error=attempted text search inside compressed tarball produced no matches, next=inspect with tar -tf/tar -xOf instead
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770837802-7a10
> failure: cmd=tools/bun_loop.sh, exit=1, error=BuildCares.cmake blocked by BUN_BOOTSTRAP=OFF external repository download guard, next=add minimal USE_SYSTEM_CARES path in Formula/b/bun.rb to bypass register_repository
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770837602-ede5
> failure: cmd=brew style Formula/b/bun.rb && brew audit --strict bun after adding brotli, exit=1, error='FormulaAudit/DependencyOrder for brotli/libuv', next=reorder runtime depends_on lines alphabetically (brotli before libuv).
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770837089-e79f
> bun bootstrap-off: add USE_SYSTEM_BORINGSSL path in BuildBoringSSL.cmake via formula inreplace, map crypto/ssl/decrepit targets to system OpenSSL and set -DUSE_SYSTEM_BORINGSSL=ON; configure advances from BuildBoringSSL to BuildBrotli
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770837065-c087
> failure: cmd=rg -n 'Using system OpenSSL|BuildBrotli|BuildBoringSSL|NETWORK_ACTIVITY_DETECTED|SUCCESS' logs/bun/summary-20260211-140825.txt, exit=1, error='no matches in filtered summary', next=inspect summary file directly and cross-check Homebrew build log text
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770836865-3521
> failure: cmd=sed -n '1,220p' /private/tmp/.../BuildBoringSSL.cmake, exit=1, error='No such file or directory' due ephemeral tmp path cleanup, next=inspect BuildBoringSSL.cmake from brew cache tarball
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770836651-97c4
> bun bootstrap-off: vendor picohttpparser as formula resource and gate BuildBun picohttpparser register_repository on local vendor source; advances configure past BuildBun.cmake:764 to next blocker in BuildBoringSSL
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770836624-38a5
> failure: cmd=rg -n 'Using vendored picohttpparser|CMake Error|BuildBoringSSL|NETWORK_ACTIVITY_DETECTED|SUCCESS' logs/bun/summary-20260211-140058.txt, exit=1, error='no matches in filtered summary', next=inspect summary file directly and cross-check Homebrew build log
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770836384-3f3d
> failure: cmd=sed -n '720,810p' /private/tmp/.../BuildBun.cmake, exit=1, error='No such file or directory' from wrong tmp extraction path guess, next=inspect BuildBun.cmake from brew cache tarball directly
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770836173-f632
> bun bootstrap-off: add USE_SYSTEM_ZSTD path via CloneZstd/BuildZstd inreplace, include no-op clone-zstd target to satisfy BuildBun TARGETS dependency and avoid zstd repository clone
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770835527-a700
> bun bootstrap-off: gate register_repository in cmake/Globals.cmake to fail fast before GitClone/DownloadUrl; avoids build-time repo downloads and surfaces explicit offline blocker at configure.
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770835488-539b
> failure: cmd=brew audit --strict Formula/b/bun.rb, exit=1, error='Calling brew audit [path ...] is disabled', next=use brew audit --strict bun
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770834878-5f74
> bun_loop lock contention: wait up to HOMEBREW_BUN_LOCK_WAIT_SECS for active brew, then clear stale bun/cmake locks only when no brew process is running; this avoids transient cmake lock aborts and reaches real Bun configure blockers
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770834631-8448
> failure: cmd=tools/bun_loop.sh, exit=1, error=brew install lock on /opt/homebrew/Cellar/cmake during verification rerun, next=rerun loop after lock clears to validate next blocker
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770834501-d4c8
> failure: cmd=tools/bun_loop.sh, exit=1, error=cmake formula lock held by concurrent brew process; summary now correctly avoids NETWORK_ACTIVITY_DETECTED false-positive, next=run when lock clears to reach next bun build blocker
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770834458-39dd
> failure: cmd=tools/bun_loop.sh, exit=2, error=brew install lock on /opt/homebrew/Cellar/cmake causing false NETWORK_ACTIVITY_DETECTED from 'Fetching downloads for: bun', next=clear stale process/lock and narrow detector pattern
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770834385-e348
> failure: cmd=tools/bun_loop.sh after strict multiline inreplace, exit=2, error=inreplace failed in cmake/Globals.cmake due exact block mismatch, next=anchor replacement on register_bun_install COMMENT stanza
<!-- tags: bun, formula, error-handling | created: 2026-02-11 -->

### mem-1770834112-247b
> bun_loop: set -e/pipefail with tee can exit before summary generation; wrap build pipeline in set +e, capture PIPESTATUS[0], restore set -e, and add fallback summary when extractor matches nothing
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

### mem-1770833939-6de9
> failure: cmd=ls -1t logs/bun/summary-*.txt, exit=1, error='no matches found' because tools/bun_loop.sh exits early on brew failure under set -e before writing summary, next=wrap install step to always produce summary file
<!-- tags: bun, tooling, error-handling | created: 2026-02-11 -->

## Context
