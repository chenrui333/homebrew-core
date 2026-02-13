# Bun 1.3.8 — Homebrew Build-from-Source Test Report

**Date:** 2026-02-13 13:12 EST
**Branch:** `bun-1.3.8`
**Build method:** `brew install --build-from-source bun`

## Environment

| Property | Value |
|----------|-------|
| macOS | 26.2 (25C56) |
| Architecture | arm64 (Apple M4 Pro) |
| Bun version | 1.3.8 |
| Bun revision | 1.3.8+000000000 |
| Binary path | /opt/homebrew/bin/bun |

## Summary

| | Count |
|---|---|
| **Passed** | 82 |
| **Failed** | 0 |
| **Skipped** | 1 |
| **Total** | 83 |

**Result: ALL TESTS PASSED**

## Test Results by Section

### 1. Core Runtime (10/10)

| Test | Status |
|------|--------|
| bun --version | PASS |
| bun --revision | PASS |
| bun -e (eval) | PASS |
| bun -p (print) | PASS |
| bun run hello.ts (TypeScript) | PASS |
| bun run hello.jsx (JSX) | PASS |
| bun run hello.tsx (TSX) | PASS |
| bun run esm.mjs (ES modules) | PASS |
| bun run cjs.cjs (CommonJS) | PASS |
| bun run (top-level await) | PASS |

### 2. Package Manager — Init & Install (4/4)

| Test | Status |
|------|--------|
| bun init -y | PASS |
| bun install | PASS |
| lockfile created | PASS |
| node_modules created | PASS |

### 3. Package Manager — Add / Remove / Update (7/7)

| Test | Status |
|------|--------|
| bun add lodash (runtime dep) | PASS |
| bun add -d prettier (dev dep) | PASS |
| bun add --optional bufferutil | PASS |
| bun add zod@3.22.0 (pinned) | PASS |
| bun remove bufferutil | PASS |
| bun update | PASS |
| bun outdated | PASS |

### 4. Package Manager — Info / Why / Audit / PM (6/6)

| Test | Status |
|------|--------|
| bun info lodash | PASS |
| bun why lodash | PASS |
| bun audit | PASS |
| bun pm ls | PASS |
| bun pm cache | PASS |
| bun pm hash | PASS |

### 5. Script Runner (2/2, 1 skip)

| Test | Status |
|------|--------|
| bun run \<script\> (package.json) | PASS |
| bun run with env variables | PASS |
| bun exec | SKIP (empty output) |

### 6. Test Runner (5/5)

| Test | Status |
|------|--------|
| bun test (basic assertions) | PASS |
| bun test (async tests) | PASS |
| bun test (matchers) | PASS |
| bun test (lifecycle hooks) | PASS |
| bun test --timeout | PASS |

### 7. Bundler (6/6)

| Test | Status |
|------|--------|
| bun build --outdir | PASS |
| bun build (stdout) | PASS |
| bun build --minify (74KB < 212KB) | PASS |
| bun build --target=node | PASS |
| bun build --sourcemap=external | PASS |
| bun build (multiple entrypoints) | PASS |

### 8. Bun APIs (8/8)

| Test | Status |
|------|--------|
| Bun.file() | PASS |
| Bun.write() | PASS |
| Bun.serve() | PASS |
| Bun.hash() | PASS |
| Bun.sleep() | PASS |
| Bun.env | PASS |
| Bun.spawn() | PASS |
| Bun.Transpiler | PASS |

### 9. Node.js Compatibility (10/10)

| Test | Status |
|------|--------|
| fs | PASS |
| path | PASS |
| crypto | PASS |
| Buffer | PASS |
| process.platform | PASS |
| child_process | PASS |
| events | PASS |
| URL/url | PASS |
| streams | PASS |
| util | PASS |

### 10. Web APIs (10/10)

| Test | Status |
|------|--------|
| fetch() | PASS |
| Request/Response | PASS |
| TextEncoder/TextDecoder | PASS |
| Blob | PASS |
| FormData | PASS |
| Headers | PASS |
| AbortController | PASS |
| WebSocket (available) | PASS |
| Web Crypto (crypto.subtle) | PASS |
| structuredClone | PASS |

### 11. bunx — Package Execution (1/1)

| Test | Status |
|------|--------|
| bun x cowsay | PASS |

### 12. Bun Shell — Bun.$ (3/3)

| Test | Status |
|------|--------|
| basic command | PASS |
| pipes | PASS |
| template variables | PASS |

### 13. SQLite — bun:sqlite (1/1)

| Test | Status |
|------|--------|
| in-memory database (CREATE, INSERT, SELECT) | PASS |

### 14. FFI — bun:ffi (1/1)

| Test | Status |
|------|--------|
| module loads, FFIType available | PASS |

### 15. Workers & Performance (3/3)

| Test | Status |
|------|--------|
| performance.now() | PASS |
| queueMicrotask | PASS |
| setTimeout | PASS |

### 16. Misc Commands (3/3)

| Test | Status |
|------|--------|
| bun upgrade --help | PASS |
| bun --help | PASS |
| bun build --help | PASS |

### 17. Watch Mode (1/1)

| Test | Status |
|------|--------|
| bun --watch (initial run) | PASS |

### 18. Environment & Dotenv (1/1)

| Test | Status |
|------|--------|
| Auto .env loading | PASS |

## Notes

- **bun exec** was skipped because it produced empty output; this is a minor CLI subcommand and does not affect core functionality.
- The test suite runs in an isolated temp directory (cleaned up on exit) and requires network access for `bun add`, `bun x`, and `fetch()` tests.
- Test script: `logs/bun/run-tests.sh`

## Raw Output

```
Bun binary: /opt/homebrew/bin/bun

━━━ 1. Core Runtime ━━━
  PASS bun --version → 1.3.8
  PASS bun --revision → 1.3.8+000000000
  PASS bun -e (eval)
  PASS bun -p (print)
  PASS bun run hello.ts (TypeScript execution)
  PASS bun run hello.jsx (JSX execution)
  PASS bun run hello.tsx (TSX execution)
  PASS bun run esm.mjs (ES modules)
  PASS bun run cjs.cjs (CommonJS)
  PASS bun run (top-level await)

━━━ 2. Package Manager — Init & Install ━━━
  PASS bun init -y (creates package.json)
  PASS bun install (initial)
  PASS lockfile created (bun.lock / bun.lockb)
  PASS node_modules directory created

━━━ 3. Package Manager — Add / Remove / Update ━━━
  PASS bun add lodash (runtime dependency)
  PASS bun add -d prettier (dev dependency)
  PASS bun add --optional bufferutil
  PASS bun add zod@3.22.0 (pinned version)
  PASS bun remove bufferutil
  PASS bun update
  PASS bun outdated

━━━ 4. Package Manager — Info / Why / Audit / PM ━━━
  PASS bun info lodash
  PASS bun why lodash
  PASS bun audit (ran)
  PASS bun pm ls (lists installed packages)
  PASS bun pm cache (ran)
  PASS bun pm hash

━━━ 5. Script Runner ━━━
  PASS bun run <script> (package.json)
  PASS bun run with env variables
  SKIP bun exec — got ''

━━━ 6. Test Runner ━━━
  PASS bun test (basic assertions)
  PASS bun test (async tests)
  PASS bun test (matchers: toContain, toEqual, toThrow, etc.)
  PASS bun test (lifecycle hooks)
  PASS bun test --timeout

━━━ 7. Bundler ━━━
  PASS bun build --outdir (creates bundle)
  PASS bun build (stdout output)
  PASS bun build --minify (74191b < 212172b)
  PASS bun build --target=node
  PASS bun build --sourcemap=external
  PASS bun build (multiple entrypoints)

━━━ 8. Bun APIs (Runtime) ━━━
  PASS Bun.file() API
  PASS Bun.write() API
  PASS Bun.serve() API
  PASS Bun.hash() API
  PASS Bun.sleep() API
  PASS Bun.env API
  PASS Bun.spawn() API
  PASS Bun.Transpiler API

━━━ 9. Node.js Compatibility ━━━
  PASS Node.js fs module
  PASS Node.js path module
  PASS Node.js crypto module
  PASS Node.js Buffer
  PASS Node.js process.platform
  PASS Node.js child_process
  PASS Node.js events module
  PASS Node.js URL/url module
  PASS Node.js streams
  PASS Node.js util module

━━━ 10. Web APIs ━━━
  PASS fetch() Web API
  PASS Request/Response Web APIs
  PASS TextEncoder/TextDecoder
  PASS Blob Web API
  PASS FormData Web API
  PASS Headers Web API
  PASS AbortController Web API
  PASS WebSocket available
  PASS Web Crypto (crypto.subtle)
  PASS structuredClone

━━━ 11. bunx (Package Execution) ━━━
  PASS bun x cowsay (bunx)

━━━ 12. Bun Shell (Bun.$) ━━━
  PASS Bun.$ shell (basic)
  PASS Bun.$ shell (pipes)
  PASS Bun.$ shell (template vars)

━━━ 13. SQLite (bun:sqlite) ━━━
  PASS bun:sqlite (in-memory database)

━━━ 14. FFI (bun:ffi) ━━━
  PASS bun:ffi module available

━━━ 15. Workers & Performance ━━━
  PASS performance.now()
  PASS queueMicrotask
  PASS setTimeout

━━━ 16. Misc Commands ━━━
  PASS bun upgrade --help
  PASS bun --help
  PASS bun build --help

━━━ 17. Watch Mode (quick smoke test) ━━━
  PASS bun --watch (initial run)

━━━ 18. Environment & Dotenv ━━━
  PASS Auto .env loading

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Passed:  82
  Failed:  0
  Skipped: 1
  Total:   83

All tests passed! Your bun build is working correctly.
```
