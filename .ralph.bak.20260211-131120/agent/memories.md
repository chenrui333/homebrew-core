# Memories

## Patterns

## Decisions

## Fixes

### mem-1770463110-32d7
> failure: cmd=brew style Formula/b/bun.rb && brew audit --strict bun, exit=1, error=Style/InvertibleUnlessCondition on webkit_candidates any?/unless, next=rewrite as none?/if and rerun strict checks
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770463110-fc08
> fix: Formula/b/bun.rb now fails fast for WEBKIT_LOCAL=ON when libWTF.a is missing and supports HOMEBREW_BUN_WEBKIT_PATH via -DWEBKIT_PATH, replacing late ninja missing-archive failure
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770462672-9b2e
> failure: cmd=tools/bun_loop.sh, exit=1, error=build fails at ninja missing vendor/WebKit/WebKitBuild/Release/lib/libWTF.a with WEBKIT_LOCAL=ON, next=either provide local WebKit artifacts via WEBKIT_PATH or add non-download path to system JavaScriptCore/WebKit libs
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770462672-750b
> fix: Formula/b/bun.rb now passes -DWEBKIT_LOCAL=ON so bootstrap-off configure bypasses SetupWebKit download path; loop advances from SetupWebKit guard to build-stage missing local WebKit static libs
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770462612-34a8
> failure: cmd=ls -1t logs/bun/summary-*.txt 2>/dev/null | head -n 1, exit=1, error=zsh no matches found for summary glob, next=use 'ls -1t logs/bun/summary-*.txt(N)' or fallback to latest build log
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770462601-75d4
> failure: cmd=sed -n '1,240p' /private/tmp/bun-20260207-61032-vj7wrb/bun-bun-v1.3.8/cmake/tools/SetupWebKit.cmake, exit=1, error=no such file or directory (Homebrew cleaned buildpath), next=inspect SetupWebKit.cmake from fresh tarball unpack
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770462460-64f0
> fix: Formula/b/bun.rb now seeds cmake/sources/ZigSources.txt when tarball omits it; configure advances to next blocker at SetupWebKit.cmake bootstrap-off WEBKIT_PATH guard.
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770462460-2f27
> failure: cmd=tools/bun_loop.sh, exit=1, error=configure now fails at SetupWebKit.cmake guard requiring local WEBKIT_PATH with BUN_BOOTSTRAP=OFF after ZigSources unblock, next=either provide local WEBKIT_PATH or add minimal bootstrap-off guard path for prebuilt local WebKit
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770462211-95b8
> fix: Formula/b/bun.rb now seeds cmake/sources/BindgenSources.txt when tarball omits it; configure advances to next missing manifest ZigSources.txt before WebKit bootstrap-off guard.
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770462111-7b8b
> failure: cmd=ls -1t logs/bun/summary-*.txt, exit=1, error=zsh no matches for summary path, next=use latest logs/bun/build-*.log fallback and optionally harden bun_loop summary emission
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770461951-076f
> fix: Formula/b/bun.rb now guards SetupWebKit.cmake download block when BUN_BOOTSTRAP=OFF, failing fast with local WEBKIT_PATH guidance; loop now stops before WebKit network fetch.
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770461851-2f56
> failure: cmd=tools/bun_loop.sh, exit=1, error=inreplace pattern for SetupWebKit download line did not match, next=inspect exact SetupWebKit.cmake file(DOWNLOAD...) syntax and tighten regex
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770461705-c8cc
> failure: cmd=timeout 900 HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source ./Formula/b/bun.rb -v, exit=127, error=timeout executed env assignment as command, next=rerun with 'env HOMEBREW_NO_INSTALL_FROM_API=1' before brew
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770461414-e7cb
> failure: cmd=timeout 900 tools/bun_loop.sh, exit=1, error=brew install lock on /opt/homebrew/Cellar/bun due concurrent/stalled install, next=identify lock holder process and terminate stale build before rerun
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770460951-4e80
> failure: cmd=tools/bun_loop.sh, exit=1, error=configure fails at cmake/Globals.cmake:552 register_command OUTPUTS/ARTIFACTS required (BuildBun.cmake:459) with BUN_BOOTSTRAP=OFF, next=patch bun.rb inline BuildBun.cmake to provide OUTPUTS/ARTIFACTS or ALWAYS_RUN for first failing command
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770460835-8f1f
> fix: Formula/b/bun.rb bootstrap-off path now sets BUN_EXECUTABLE=true in SetupBun.cmake inline patch, which advances configure beyond BuildBun.cmake:441 execute_process ENOENT to next blocker at Globals.cmake:552 register_command OUTPUTS/ARTIFACTS.
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770460635-8278
> fix: Formula/b/bun.rb now downgrades bootstrap-off BuildBun.cmake bindgen/codegen guards to STATUS and repairs hunk metadata (+1583,6) so inline patch applies; loop now advances to native failure at BuildBun.cmake:441 execute_process ENOENT (bun-required codegen path).
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770460548-a282
> failure: cmd=patch -p1 --dry-run on Formula/b/bun.rb __END__, exit=2, error=malformed patch at line 61 before SetupBun.cmake diff, next=repair BuildBun.cmake hunk header counts to match current inserted lines
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770460263-66e1
> fix: Formula/b/bun.rb patch now adds an early BuildBun.cmake bindgen guard when BUN_BOOTSTRAP is OFF, replacing opaque execute_process ENOENT with actionable fatal guidance; first blocker is confirmed codegen/bootstrap requirement.
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770460112-916c
> failure: cmd=for f in /Users/rchen/Library/Logs/Homebrew/bun/*patch* ..., exit=1, error=zsh no matches found for patch glob, next=use glob-safe find/ls checks before tailing logs
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770460097-bf12
> failure: cmd=tools/bun_loop.sh, exit=1, error=patch -g 0 -f -p1 exited with 2 while applying BuildBun.cmake hunk in Formula/b/bun.rb, next=repair inline patch metadata/hunks so Homebrew patching succeeds
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770459973-8479
> failure: cmd=ls -1t logs/bun/summary-*.txt, exit=1, error=zsh no matches because bun_loop exits early on failed pipeline before writing summary, next=inspect latest logs/bun/build-*.log or patch bun_loop summary generation after failure.
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770459957-0a6b
> fix: Formula/b/bun.rb now seeds cmake/sources/BindgenV2Sources.txt and BindgenV2InternalSources.txt when tarball omits them; configure advances to next blocker at BuildBun.cmake execute_process (line 437).
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459843-8758
> fix: Formula/b/bun.rb now seeds cmake/sources/BakeRuntimeSources.txt when tarball omits it; configure advances to next missing manifests BindgenV2Sources.txt and BindgenV2InternalSources.txt
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459733-a5f6
> fix: Formula/b/bun.rb now seeds cmake/sources/JavaScriptCodegenSources.txt when tarball omits it; configure advances to next missing manifest BakeRuntimeSources.txt
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459633-49ea
> fix: Formula/b/bun.rb now seeds cmake/sources/JavaScriptSources.txt when tarball omits it; configure advances to next missing manifest JavaScriptCodegenSources.txt
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459517-51b1
> fix: Formula/b/bun.rb now seeds cmake/sources/CSources.txt when tarball omits it; configure advances to next missing manifest JavaScriptSources.txt
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459409-f2ef
> fix: Formula/b/bun.rb now seeds cmake/sources/CxxSources.txt when tarball omits it; configure advances to next missing manifest CSources.txt
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459360-f8fe
> failure: cmd=ls -1t logs/bun/summary-*.txt, exit=1, error=zsh no matches found, next=use latest logs/bun/build-*.log as source of first failure when summaries are absent
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770459298-6bfa
> fix: Formula/b/bun.rb now seeds cmake/sources/ZigGeneratedClassesSources.txt when tarball omits it; configure advances to next missing manifests (CxxSources/CSources/JavaScript*/BakeRuntime/BindgenV2*).
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459234-53e8
> failure: cmd=ls -1t logs/bun/summary-*.txt, exit=1, error=zsh no matches for summary path, next=inspect tools/bun_loop.sh for actual summary location and use that path
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770459180-20fb
> fix: Formula/b/bun.rb now seeds NodeFallbacksSources.txt with actual node-fallback JS entries; configure advances past register_command outputs check and next blockers are missing ZigGenerated/Cxx/C/JavaScript source-list manifests
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770459043-2514
> failure: cmd=rg -n register_command ... cmake/targets/BuildBun.cmake, exit=2, error=cmake files not in tap tree (patched inline in Formula/b/bun.rb), next=edit inline __END__ patch blocks in formula
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770459043-0446
> failure: cmd=ls -1t logs/bun/summary-*.txt | head -n 1, exit=1, error=zsh no matches for summary path, next=inspect build log directly and verify bun_loop summary output location
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770458977-4c1b
> fix: Formula/b/bun.rb now seeds cmake/sources/BunErrorSources.txt and NodeFallbacksSources.txt so configure advances past missing-manifest errors; next blocker is register_command OUTPUTS/ARTIFACTS requirement in cmake/targets/BuildBun.cmake:184
<!-- tags: bun, homebrew, cmake, error-handling | created: 2026-02-07 -->

### mem-1770458877-da75
> failure: cmd=ls -1t logs/bun/summary-*.txt, exit=1, error=zsh no matches for summary path, next=inspect tools/bun_loop.sh output paths and read latest summary from actual location
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770458799-d574
> failure: cmd=tools/bun_loop.sh, exit=1, error=cmake configure fails on missing cmake/sources/BunErrorSources.txt and NodeFallbacksSources.txt before build, next=add minimal tarball fallback for missing source-list files in Bun cmake path
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770458710-6083
> failure: cmd=tools/bun_loop.sh, exit=1, error=Formula/b/bun.rb raises wrong constant name before build, next=inspect recent bun.rb guard and patch minimal syntax/runtime issue then rerun loop
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770458429-947b
> failure: cmd=kill 8808 && rm bun lockfiles, exit=policy-blocked, error=command rejected by policy, next=wait for active brew install to exit naturally then rerun bun loop
<!-- tags: tooling, policy, error-handling, bun | created: 2026-02-07 -->

### mem-1770458401-9c8d
> failure: cmd=tools/bun_loop.sh, exit=1, error=brew install lock on /opt/homebrew/Cellar/bun, next=clear stale bun formula/cellar locks and rerun loop
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770457953-04d1
> failure: cmd=tools/bun_loop.sh, exit=1, error=brew install lock on /opt/homebrew/Cellar/ninja, next=clear stale formula lock files and rerun
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

### mem-1770457937-29e0
> failure: cmd=rm -f /opt/homebrew/var/homebrew/locks/cmake.formula.lock && tools/bun_loop.sh, exit=policy-blocked, error=command rejected by policy, next=use Homebrew lock-safe workflow to clear stale lock then rerun loop
<!-- tags: tooling, policy, error-handling, bun | created: 2026-02-07 -->

### mem-1770457922-b95d
> failure: cmd=tools/bun_loop.sh, exit=1, error=brew install lock on /opt/homebrew/Cellar/cmake from concurrent process, next=identify and terminate stale brew install process then rerun loop
<!-- tags: tooling, homebrew, error-handling, bun | created: 2026-02-07 -->

## Context

### mem-1770458617-7540
> bun formula now fails fast before build when HOMEBREW_BUN_ALLOW_BOOTSTRAP is not set, preventing bootstrap bun download and surfacing codegen dependency immediately
<!-- tags: bun, build, network, homebrew | created: 2026-02-07 -->

### mem-1770458112-341d
> bun 1.3.8 loop evidence: build-20260207-045240.log shows network triggers at line 9 (bootstrap bun curl), line 102 (WEBKIT_DOWNLOAD_URL), repeated GitClone.cmake, and lines 1437-1438 (Downloading zig/DownloadZig.cmake)
<!-- tags: bun, build, network, homebrew | created: 2026-02-07 -->
