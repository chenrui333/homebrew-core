# Memories

## Patterns

## Decisions

## Fixes

### mem-1770902775-a7d8
> bun bootstrap-on: rewrote JSCInlines include for WeakGCSetInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/WeakGCSetInlines.h to next header in JSCInlines.h chain
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770897998-4bec
> failure: cmd=HOMEBREW_BUN_LOCK_WAIT_SECS=0 tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun during verification run', next=wait for/clear active brew install process and rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770897975-a912
> failure: cmd=brew uninstall --force bun && brew audit --strict bun, exit=1, error='lock on /opt/homebrew/Cellar/zig while uninstall/autoremove active', next=wait for active brew uninstall/autoremove to finish and rerun brew audit --strict bun'
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770897961-25b7
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from local bun keg state', next=remove stale local bun installation and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770897929-facd
> failure: cmd=rg -n "NETWORK_ACTIVITY_DETECTED|SUCCESS|WeakGCMapInlines|fatal error|FAILED:" logs/bun/summary-20260212-065542.txt, exit=1, error='no matches in generated summary', next=inspect full build log referenced by bun_loop output to confirm first blocker movement
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770897828-e0ea
> bun bootstrap-on: rewrote JSCInlines include for ThrowScope in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/ThrowScope.h to missing JavaScriptCore/WeakGCMapInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770897828-c022
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install lock on /opt/homebrew/Cellar/bun during verification run', next=terminate stale bun_loop/cmake/ninja processes and rerun bun_loop for clean blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770897180-90b1
> bun bootstrap-on: rewrote JSCInlines include for StructureInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/StructureInlines.h to missing JavaScriptCore/ThrowScope.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770897060-5955
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun during verification run', next=wait for/clear active brew install process and rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770897029-13f1
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from local bun keg state', next=remove stale local bun installation and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770896905-4188
> bun bootstrap-on: rewrote JSCInlines include for StrongInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/StrongInlines.h to missing JavaScriptCore/StructureInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770896813-ed43
> failure: cmd=brew uninstall --force bun, exit=1, error='lock on /opt/homebrew/Cellar/zig while uninstall/autoremove active', next=wait for active brew uninstall to finish then rerun uninstall/audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770896655-9ced
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun during verification rerun', next=terminate stale bun_loop/cmake/ninja processes and rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770896649-6203
> bun bootstrap-on: rewrote JSCInlines include for SlotVisitorInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/SlotVisitorInlines.h to missing JavaScriptCore/StrongInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770883880-c90a
> bun bootstrap-on: rewrote JSCInlines include for JSString in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSString.h to missing JavaScriptCore/Operations.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770883572-d686
> bun bootstrap-on: rewrote JSCInlines include for JSGlobalProxy in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSGlobalProxy.h to missing JavaScriptCore/JSString.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770883062-5f0b
> bun bootstrap-on: rewrote JSCInlines include for JSObjectInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSObjectInlines.h to missing JavaScriptCore/JSGlobalProxy.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770883026-5a71
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from interrupted local bun keg', next=remove stale local bun installation state and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770882566-440e
> bun bootstrap-on: rewrote JSCInlines include for JSGlobalObjectInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSGlobalObjectInlines.h to missing JavaScriptCore/JSObjectInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770882303-b2d4
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun during JSGlobalObjectInlines verification run', next=identify and terminate/wait for active bun brew process then rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770881915-f155
> bun bootstrap-on: rewrote JSCInlines include for JSFunctionInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSFunctionInlines.h to missing JavaScriptCore/JSGlobalObjectInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770881687-5c9e
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun during JSFunctionInlines verification run', next=identify and terminate/wait for active bun brew process then rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770881283-23ff
> bun bootstrap-on: rewrote JSCInlines include for JSCellInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSCellInlines.h to missing JavaScriptCore/JSFunctionInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770881236-7339
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from interrupted local bun keg', next=remove stale local bun installation state and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770880973-6066
> failure: cmd=tools/bun_loop.sh, exit=1, error='bun cellar locked by concurrent brew install during JSCellInlines verification run', next=identify and terminate/wait for active brew install process then rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770880542-9ca8
> bun bootstrap-on: added /../../Source/JavaScriptCore/dfg include dir via Formula/b/bun.rb SetupWebKit inreplace; bun_loop advances first blocker from missing DFGAbstractHeap.h (via DOMJITEffect.h) to missing JavaScriptCore/JSCellInlines.h in JSCInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770880542-776f
> failure: cmd=sed -n '1,220p' /private/tmp/bun-20260212-29683-yg82zn/bun-bun-v1.3.8/cmake/tools/SetupWebKit.cmake, exit=1, error='No such file or directory after tmp cleanup', next=inspect durable paths (brew cache or local WebKit tree) instead of ephemeral /private/tmp build dir
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770879941-bd3d
> bun bootstrap-on: rewrote JSCInlines include for JSCJSValueInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSCJSValueInlines.h to missing DFGAbstractHeap.h via DOMJITEffect.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770879904-b2c4
> failure: cmd=brew uninstall --force bun && brew audit --strict bun, exit=1, error='uninstall lock on /opt/homebrew/Cellar/zig from active uninstall process', next=wait for uninstall process to complete then rerun brew audit --strict bun
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770879890-af0d
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from interrupted local bun keg', next=remove stale local bun keg and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770878870-f5cb
> bun bootstrap-on: rewrote JSCInlines include for JSArrayBufferViewInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/JSArrayBufferViewInlines.h to missing JavaScriptCore/JSCJSValueInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770878646-c788
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install lock on /opt/homebrew/Cellar/bun from concurrent process after lock-wait timeout', next=identify and terminate/wait for active bun brew process then rerun bun_loop for clean blocker verification
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770878256-a105
> bun bootstrap-on: rewrote JSCInlines include for IdentifierInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/IdentifierInlines.h to missing JavaScriptCore/JSArrayBufferViewInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770878208-8f1b
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from interrupted local bun keg', next=remove stale local bun keg and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770877999-3adf
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun during verification rerun', next=identify and clear active bun brew process then rerun bun_loop for clean first-blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770877652-a04a
> failure: cmd=sed -n '1,220p' /Users/rchen/.codex/skills/ralph-tools/SKILL.md, exit=1, error='No such file or directory', next=load the skill via ralph tools skill load ralph-tools and use built-in guidance
<!-- tags: tooling, error-handling | created: 2026-02-12 -->

### mem-1770877608-8afb
> bun bootstrap-on: rewrote JSCInlines include for HeapInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/HeapInlines.h to missing JavaScriptCore/IdentifierInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770877400-ee98
> failure: cmd=kill 66550 66549 63714 && sleep 1 && pgrep -fl 'brew install --build-from-source ./Formula/b/bun.rb -v|tools/bun_loop.sh|cmake --build build|ninja -v', exit=1, error='post-kill pgrep returned no matches', next=treat as successful stale-process cleanup and avoid chained match-required pgrep for status checks
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770877386-8e4e
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun after lock-wait window', next=identify and terminate/wait for active brew install process then rerun bun_loop for clean first-blocker verification
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770876981-b429
> bun bootstrap-on: rewrote JSCInlines include for GCIncomingRefCountedInlines in Formula/b/bun.rb to flat private header include; bun_loop advances first blocker from missing JavaScriptCore/GCIncomingRefCountedInlines.h to missing JavaScriptCore/HeapInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770876976-e6d0
> failure: cmd=rg -n 'GCIncomingRefCountedInlines|HeapInlines|NETWORK_ACTIVITY_DETECTED|SUCCESS' logs/bun/summary-20260212-011032.txt, exit=1, error='no matches in generated summary', next=use full bun_loop build output to confirm blocker movement when summary extractor misses compiler diagnostics
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770876771-fd9e
> failure: cmd=tools/bun_loop.sh, exit=1, error='concurrent brew install locked /opt/homebrew/Cellar/bun after lock-wait window', next=terminate/wait for active brew install process and rerun bun_loop for clean first-blocker verification
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770876381-b077
> bun bootstrap-on: added JavaScriptCore.framework/Headers to SetupWebKit include dirs via Formula/b/bun.rb inreplace; bun_loop advances first blocker from missing JSBase.h to missing JavaScriptCore/GCIncomingRefCountedInlines.h in JSCInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770876381-74f6
> failure: cmd=brew uninstall --force bun, exit=1, error='lock on /opt/homebrew/Cellar/zig while bun_loop build still active', next=terminate active bun_loop/cmake/ninja processes and rerun uninstall/audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770876381-5295
> failure: cmd=brew audit --strict bun, exit=1, error='installation seems to be empty from interrupted local bun keg', next=clear stale bun installation (after stopping active bun loop process) and rerun audit
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770875751-74ac
> bun bootstrap-on: rewrote JSCInlines include for ExceptionHelpers in Formula/b/bun.rb; bun_loop advances first blocker from missing JavaScriptCore/ExceptionHelpers.h to missing JSBase.h via JSHeapFinalizerPrivate.h in WebKit private header chain
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770875244-fb41
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install lock on /opt/homebrew/Cellar/bun after 120s wait', next=wait for/clear active brew install process then rerun bun_loop for blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770874830-72ab
> failure: cmd=git commit -m 'bun: prototype webkit private header path', exit=128, error='existing .git/index.lock (likely concurrent git invocation)', next=remove stale index.lock and rerun commit serially
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770874817-9d95
> bun bootstrap-on: patched Formula/b/bun.rb to map root.h JSC private includes to flat headers and include JavaScriptCore.framework/PrivateHeaders in SetupWebKit local include dirs; bun_loop advances first blocker from missing JavaScriptCore/JSCJSValue.h to missing JavaScriptCore/ExceptionHelpers.h in JSCInlines.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770874772-4c7d
> failure: cmd=brew uninstall --force bun, exit=1, error='lock on /opt/homebrew/Cellar/zig during uninstall while stale brew process active', next=clear active brew process/locks and rerun uninstall or verify bun keg removed
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770874243-80b5
> failure: cmd=tools/bun_loop.sh, exit=1, error='EPERM creating /Users/rchen/Downloads/brew/bun-WebKit/WebKitBuild/Release/JavaScriptCore/PrivateHeaders from formula shim step', next=avoid mutating external WebKit tree and patch Bun include directives in source instead
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770873780-436d
> failure: cmd=tools/bun_loop.sh, exit=1, error='bun cellar lock held by concurrent brew install during JSC header verification run', next=wait for active brew install process to finish and rerun bun_loop for clean blocker confirmation
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770873234-ee3b
> bun bootstrap-on: disabled BuildBun.cmake target_precompile_headers block via formula inreplace; bun_loop no longer fails at cmake_pch.hxx.pch and first blocker advances to missing JavaScriptCore/JSCJSValue.h in root.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770873230-d8d1
> failure: cmd=tools/bun_loop.sh, exit=2, error='compile fails at GeneratedBindings.cpp with JavaScriptCore/JSCJSValue.h missing after disabling PCH', next=patch WebKit include path/header staging in Formula/b/bun.rb to expose JSCJSValue.h during compile
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770873023-2c5b
> failure: cmd=kill ... | rg ..., exit=1, error='post-cleanup rg returned no matches', next=treat as successful stale-process cleanup and avoid piping through match-required rg for status checks
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770872751-2a6a
> failure: cmd=tools/bun_loop.sh, exit=1, error='bun cellar lock held by concurrent brew install', next=wait for active brew install process to exit before rerunning bun_loop
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770872057-def4
> failure: cmd=tools/bun_loop.sh after initial node-fallback placeholder, exit=1, error='register_command merged multiple cmake -E commands causing placeholder generation failure', next=replace with single shell COMMAND and flatten list with string(REPLACE ';' ' ').
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770872057-8edc
> bun bootstrap-on: node-fallbacks placeholder branch now skips build-fallbacks when node_modules/assert is missing and creates codegen placeholder files via single shell command; bun_loop advances first blocker from node-fallbacks missing node_modules to cmake_pch.hxx.pch compile.
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770868405-82f9
> bun bootstrap-on: replaced BuildBun register_bun_install blocks for bun-error and node-fallbacks with no-op markers via formula inreplace; build log shows skipped bun installs and blocker advances to missing node-fallbacks/react-refresh inputs.
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770868079-4416
> failure: cmd=tools/bun_loop.sh, exit=1, error='brew install already locked /opt/homebrew/Cellar/bun by another process', next=identify active bun brew process and rerun loop after lock clears for clean blocker evidence.
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770867940-e612
> failure: cmd=brew audit --strict bun after skipping register_bun_install in BuildBun.cmake, exit=1, error='The installation seems to be empty', next=use bun_loop/build log to confirm first compile blocker and revisit no-op install approach if it prevents artifacts needed for audit.
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770867511-36df
> failure: cmd=tools/bun_loop.sh session terminated after manual kill during long build, exit=2, error='SIGTERM in Homebrew install subprocess', next=avoid mid-build termination unless needed; use log tail to capture first blocker if loop output channel stalls
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

### mem-1770867511-1179
> bun bootstrap-on: patched SetupBun.cmake via formula inreplace to download and extract platform bun-v zip when BUN_EXECUTABLE is missing; configure now uses downloaded bootstrap Bun and advances first blocker from bindgen execute_process no-such-file to compile-time missing JavaScriptCore/JSCJSValue.h
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770867511-c31c
> failure: cmd=brew style Formula/b/bun.rb + brew audit --strict bun with bootstrap *.zip resources, exit=1, error='FormulaAudit/Urls flags binary package URLs; homebrew/core is source-only', next=remove binary resources and implement bootstrap bun download fallback inside SetupBun.cmake patch
<!-- tags: bun, formula, error-handling | created: 2026-02-12 -->

### mem-1770866946-1a2d
> failure: cmd=sed/nl/rg on guessed /private/tmp/bun-* path for BuildBun.cmake, exit=1/2, error='No such file or directory', next=locate active build tree with filesystem search before inspecting line context
<!-- tags: bun, tooling, error-handling | created: 2026-02-12 -->

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
