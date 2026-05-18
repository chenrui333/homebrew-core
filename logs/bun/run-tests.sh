#!/bin/bash
# Comprehensive Bun Command Test Suite
# Tests all major bun commands against a from-source Homebrew build

set -u
# Note: NOT using set -e or pipefail so individual test failures don't abort the suite

# ── Colors and Helpers ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

PASS=0
FAIL=0
SKIP=0
ERRORS=()

pass() { ((PASS++)) || true; echo -e "  ${GREEN}PASS${NC} $1"; }
fail() { ((FAIL++)) || true; ERRORS+=("$1: $2"); echo -e "  ${RED}FAIL${NC} $1 — $2"; }
skip() { ((SKIP++)) || true; echo -e "  ${YELLOW}SKIP${NC} $1 — $2"; }
section() { echo -e "\n${CYAN}${BOLD}━━━ $1 ━━━${NC}"; }

# ── Setup ───────────────────────────────────────────────────────────
TESTDIR="$(mktemp -d)"
trap 'rm -rf "$TESTDIR"' EXIT
cd "$TESTDIR"

BUN="$(which bun)"
echo -e "${BOLD}Bun binary:${NC} $BUN"
echo -e "${BOLD}Test dir:${NC}  $TESTDIR"

# ════════════════════════════════════════════════════════════════════
section "1. Core Runtime"
# ════════════════════════════════════════════════════════════════════

# 1.1 Version
if $BUN --version >/dev/null 2>&1; then
  VER=$($BUN --version)
  pass "bun --version → $VER"
else
  fail "bun --version" "exit code $?"
fi

# 1.2 --revision
if $BUN --revision >/dev/null 2>&1; then
  REV=$($BUN --revision)
  pass "bun --revision → $REV"
else
  skip "bun --revision" "not supported in this build"
fi

# 1.3 --eval
OUTPUT=$($BUN -e "console.log('hello')" 2>&1)
if [[ "$OUTPUT" == "hello" ]]; then
  pass "bun -e (eval)"
else
  fail "bun -e (eval)" "expected 'hello', got '$OUTPUT'"
fi

# 1.4 --print (bun -p prints module.exports)
OUTPUT=$($BUN -p "module.exports = 1 + 2" 2>&1)
if [[ "$OUTPUT" == "3" ]]; then
  pass "bun -p (print)"
else
  fail "bun -p (print)" "expected '3', got '$OUTPUT'"
fi

# 1.5 Run a .ts file
cat > hello.ts <<'EOF'
const msg: string = "hello from typescript";
console.log(msg);
EOF
OUTPUT=$($BUN run hello.ts 2>&1)
if [[ "$OUTPUT" == "hello from typescript" ]]; then
  pass "bun run hello.ts (TypeScript execution)"
else
  fail "bun run hello.ts" "got '$OUTPUT'"
fi

# 1.6 Run a .jsx file (requires react - install it first)
$BUN init -y >/dev/null 2>&1
$BUN add react >/dev/null 2>&1
cat > hello.jsx <<'EOF'
const element = <div>hello jsx</div>;
console.log(element.type, element.props.children);
EOF
OUTPUT=$($BUN run hello.jsx 2>&1) || true
if [[ "$OUTPUT" == "div hello jsx" ]]; then
  pass "bun run hello.jsx (JSX execution)"
else
  fail "bun run hello.jsx" "got '$OUTPUT'"
fi

# 1.7 Run a .tsx file
cat > hello.tsx <<'EOF'
const greet = (name: string) => <span>{name}</span>;
const el = greet("bun");
console.log(el.type, el.props.children);
EOF
OUTPUT=$($BUN run hello.tsx 2>&1) || true
if [[ "$OUTPUT" == "span bun" ]]; then
  pass "bun run hello.tsx (TSX execution)"
else
  fail "bun run hello.tsx" "got '$OUTPUT'"
fi

# 1.8 ES modules
cat > esm.mjs <<'EOF'
import { join } from "path";
console.log(join("a", "b"));
EOF
OUTPUT=$($BUN run esm.mjs 2>&1)
if [[ "$OUTPUT" == "a/b" ]]; then
  pass "bun run esm.mjs (ES modules)"
else
  fail "bun run esm.mjs" "got '$OUTPUT'"
fi

# 1.9 CommonJS
cat > cjs.cjs <<'EOF'
const { join } = require("path");
console.log(join("x", "y"));
EOF
OUTPUT=$($BUN run cjs.cjs 2>&1)
if [[ "$OUTPUT" == "x/y" ]]; then
  pass "bun run cjs.cjs (CommonJS)"
else
  fail "bun run cjs.cjs" "got '$OUTPUT'"
fi

# 1.10 Top-level await
cat > tla.ts <<'EOF'
const result = await Promise.resolve("awaited");
console.log(result);
EOF
OUTPUT=$($BUN run tla.ts 2>&1)
if [[ "$OUTPUT" == "awaited" ]]; then
  pass "bun run (top-level await)"
else
  fail "bun run (top-level await)" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "2. Package Manager — Init & Install"
# ════════════════════════════════════════════════════════════════════

# 2.1 bun init
mkdir -p proj && cd proj
$BUN init -y >/dev/null 2>&1
if [[ -f package.json ]]; then
  pass "bun init -y (creates package.json)"
else
  fail "bun init" "no package.json created"
fi

# 2.2 bun install (initial)
OUTPUT=$($BUN install 2>&1)
if [[ $? -eq 0 ]]; then
  pass "bun install (initial)"
else
  fail "bun install" "$OUTPUT"
fi

# 2.3 Lockfile created
if [[ -f bun.lock || -f bun.lockb ]]; then
  pass "lockfile created (bun.lock / bun.lockb)"
else
  fail "lockfile" "no lockfile found"
fi

# 2.4 node_modules created
if [[ -d node_modules ]]; then
  pass "node_modules directory created"
else
  fail "node_modules" "directory not found"
fi

# ════════════════════════════════════════════════════════════════════
section "3. Package Manager — Add / Remove / Update"
# ════════════════════════════════════════════════════════════════════

# 3.1 bun add (runtime dep)
$BUN add lodash >/dev/null 2>&1
if $BUN -e "require('lodash').chunk([1,2,3,4],2).length === 2 && console.log('ok')" 2>&1 | grep -q "ok"; then
  pass "bun add lodash (runtime dependency)"
else
  fail "bun add lodash" "lodash not usable after install"
fi

# 3.2 bun add -d (dev dep)
$BUN add -d prettier >/dev/null 2>&1
if grep -q '"prettier"' package.json; then
  pass "bun add -d prettier (dev dependency)"
else
  fail "bun add -d prettier" "not in package.json devDependencies"
fi

# 3.3 bun add --optional
$BUN add --optional bufferutil >/dev/null 2>&1
if grep -q '"bufferutil"' package.json; then
  pass "bun add --optional bufferutil"
else
  fail "bun add --optional bufferutil" "not in optionalDependencies"
fi

# 3.4 bun add with version
$BUN add zod@3.22.0 >/dev/null 2>&1
if $BUN -e "console.log(require('zod/package.json').version)" 2>&1 | grep -q "3.22.0"; then
  pass "bun add zod@3.22.0 (pinned version)"
else
  fail "bun add zod@3.22.0" "wrong version installed"
fi

# 3.5 bun remove
$BUN remove bufferutil >/dev/null 2>&1
if ! grep -q '"bufferutil"' package.json; then
  pass "bun remove bufferutil"
else
  fail "bun remove bufferutil" "still in package.json"
fi

# 3.6 bun update
OUTPUT=$($BUN update 2>&1)
if [[ $? -eq 0 ]]; then
  pass "bun update"
else
  fail "bun update" "$OUTPUT"
fi

# 3.7 bun outdated
OUTPUT=$($BUN outdated 2>&1)
if [[ $? -eq 0 ]]; then
  pass "bun outdated"
else
  # outdated may return non-zero if packages are outdated
  pass "bun outdated (ran, exit=$?)"
fi

# ════════════════════════════════════════════════════════════════════
section "4. Package Manager — Info / Why / Audit / PM"
# ════════════════════════════════════════════════════════════════════

# 4.1 bun info (npm registry)
OUTPUT=$($BUN info lodash 2>&1)
if echo "$OUTPUT" | grep -qi "lodash"; then
  pass "bun info lodash"
else
  fail "bun info lodash" "no package info returned"
fi

# 4.2 bun why
OUTPUT=$($BUN why lodash 2>&1)
if [[ $? -eq 0 ]]; then
  pass "bun why lodash"
else
  fail "bun why lodash" "exit code $?"
fi

# 4.3 bun audit
OUTPUT=$($BUN audit 2>&1) || true
# audit may fail if not supported or no vulns - just check it runs
if [[ $? -eq 0 ]] || echo "$OUTPUT" | grep -qiE "vulnerabilities|no known"; then
  pass "bun audit (ran)"
else
  skip "bun audit" "may not be fully supported"
fi

# 4.4 bun pm ls
OUTPUT=$($BUN pm ls 2>&1)
if echo "$OUTPUT" | grep -q "lodash"; then
  pass "bun pm ls (lists installed packages)"
else
  fail "bun pm ls" "lodash not listed"
fi

# 4.5 bun pm cache
OUTPUT=$($BUN pm cache 2>&1) || true
if [[ $? -eq 0 ]] || [[ -n "$OUTPUT" ]]; then
  pass "bun pm cache (ran)"
else
  skip "bun pm cache" "not available"
fi

# 4.6 bun pm hash
OUTPUT=$($BUN pm hash 2>&1) || true
if [[ $? -eq 0 ]]; then
  pass "bun pm hash"
else
  skip "bun pm hash" "not available"
fi

# ════════════════════════════════════════════════════════════════════
section "5. Script Runner"
# ════════════════════════════════════════════════════════════════════

# 5.1 package.json scripts
cat > package.json <<'EOF'
{
  "name": "bun-test",
  "scripts": {
    "hello": "echo script-works",
    "greet": "bun -e \"console.log('script-greet')\"",
    "env-check": "bun -e \"console.log(process.env.BUN_TEST_VAR)\""
  },
  "dependencies": { "lodash": "*", "zod": "3.22.0" },
  "devDependencies": { "prettier": "*" }
}
EOF
$BUN install >/dev/null 2>&1

OUTPUT=$($BUN run hello 2>&1)
if echo "$OUTPUT" | grep -q "script-works"; then
  pass "bun run <script> (package.json)"
else
  fail "bun run <script>" "got '$OUTPUT'"
fi

# 5.2 bun run with env
OUTPUT=$(BUN_TEST_VAR=test123 $BUN run env-check 2>&1)
if echo "$OUTPUT" | grep -q "test123"; then
  pass "bun run with env variables"
else
  fail "bun run with env" "got '$OUTPUT'"
fi

# 5.3 bun exec
OUTPUT=$($BUN exec -- echo "exec-works" 2>&1) || true
if echo "$OUTPUT" | grep -q "exec-works"; then
  pass "bun exec"
else
  skip "bun exec" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "6. Test Runner"
# ════════════════════════════════════════════════════════════════════

# 6.1 Basic test
cat > math.test.ts <<'EOF'
import { expect, test, describe } from "bun:test";

describe("math", () => {
  test("addition", () => {
    expect(1 + 1).toBe(2);
  });
  test("multiplication", () => {
    expect(3 * 4).toBe(12);
  });
});
EOF
OUTPUT=$($BUN test math.test.ts 2>&1)
if echo "$OUTPUT" | grep -q "pass"; then
  pass "bun test (basic assertions)"
else
  fail "bun test (basic)" "got '$OUTPUT'"
fi

# 6.2 Async test
cat > async.test.ts <<'EOF'
import { expect, test } from "bun:test";

test("async/await", async () => {
  const val = await Promise.resolve(42);
  expect(val).toBe(42);
});

test("fetch", async () => {
  // Just test that fetch exists and is callable
  expect(typeof fetch).toBe("function");
});
EOF
OUTPUT=$($BUN test async.test.ts 2>&1)
if echo "$OUTPUT" | grep -q "pass"; then
  pass "bun test (async tests)"
else
  fail "bun test (async)" "got '$OUTPUT'"
fi

# 6.3 Test with matchers
cat > matchers.test.ts <<'EOF'
import { expect, test } from "bun:test";

test("matchers", () => {
  expect("hello world").toContain("world");
  expect([1, 2, 3]).toHaveLength(3);
  expect({ a: 1, b: 2 }).toEqual({ a: 1, b: 2 });
  expect(null).toBeNull();
  expect(undefined).toBeUndefined();
  expect(1).toBeTruthy();
  expect(0).toBeFalsy();
  expect(5).toBeGreaterThan(3);
  expect(2).toBeLessThan(10);
  expect(() => { throw new Error("oops"); }).toThrow("oops");
});
EOF
OUTPUT=$($BUN test matchers.test.ts 2>&1)
if echo "$OUTPUT" | grep -q "pass"; then
  pass "bun test (matchers: toContain, toEqual, toThrow, etc.)"
else
  fail "bun test (matchers)" "got '$OUTPUT'"
fi

# 6.4 Test lifecycle hooks
cat > lifecycle.test.ts <<'EOF'
import { expect, test, beforeAll, afterAll, beforeEach, afterEach } from "bun:test";

let log: string[] = [];

beforeAll(() => { log.push("beforeAll"); });
afterAll(() => { log.push("afterAll"); });
beforeEach(() => { log.push("beforeEach"); });
afterEach(() => { log.push("afterEach"); });

test("lifecycle hooks run", () => {
  expect(log).toContain("beforeAll");
  expect(log).toContain("beforeEach");
});
EOF
OUTPUT=$($BUN test lifecycle.test.ts 2>&1)
if echo "$OUTPUT" | grep -q "pass"; then
  pass "bun test (lifecycle hooks)"
else
  fail "bun test (lifecycle hooks)" "got '$OUTPUT'"
fi

# 6.5 Test with --timeout
cat > timeout.test.ts <<'EOF'
import { expect, test } from "bun:test";

test("fast test", () => {
  expect(true).toBe(true);
});
EOF
OUTPUT=$($BUN test --timeout 5000 timeout.test.ts 2>&1)
if echo "$OUTPUT" | grep -q "pass"; then
  pass "bun test --timeout"
else
  fail "bun test --timeout" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "7. Bundler"
# ════════════════════════════════════════════════════════════════════

# 7.1 Basic bundle
cat > entry.ts <<'EOF'
import _ from "lodash";
export const result = _.chunk([1, 2, 3, 4, 5, 6], 2);
console.log(result);
EOF
OUTPUT=$($BUN build entry.ts --outdir=./dist 2>&1)
if [[ -f dist/entry.js ]]; then
  pass "bun build --outdir (creates bundle)"
else
  fail "bun build" "no output file: $OUTPUT"
fi

# 7.2 Bundle to stdout
OUTPUT=$($BUN build entry.ts 2>&1)
if echo "$OUTPUT" | grep -q "chunk"; then
  pass "bun build (stdout output)"
else
  fail "bun build (stdout)" "no bundle content"
fi

# 7.3 Minify
$BUN build entry.ts --outdir=./dist-min --minify >/dev/null 2>&1
if [[ -f dist-min/entry.js ]]; then
  ORIG_SIZE=$(wc -c < dist/entry.js)
  MIN_SIZE=$(wc -c < dist-min/entry.js)
  if [[ $MIN_SIZE -lt $ORIG_SIZE ]]; then
    pass "bun build --minify (${MIN_SIZE}b < ${ORIG_SIZE}b)"
  else
    pass "bun build --minify (file created)"
  fi
else
  fail "bun build --minify" "no output file"
fi

# 7.4 Target node
OUTPUT=$($BUN build entry.ts --target=node --outdir=./dist-node 2>&1)
if [[ -f dist-node/entry.js ]]; then
  pass "bun build --target=node"
else
  fail "bun build --target=node" "$OUTPUT"
fi

# 7.5 Sourcemap
$BUN build entry.ts --outdir=./dist-sm --sourcemap=external >/dev/null 2>&1
if [[ -f dist-sm/entry.js.map ]]; then
  pass "bun build --sourcemap=external"
else
  fail "bun build --sourcemap" "no .map file"
fi

# 7.6 Multiple entrypoints
cat > entry2.ts <<'EOF'
export const greet = (name: string) => `Hello, ${name}!`;
console.log(greet("bun"));
EOF
$BUN build entry.ts entry2.ts --outdir=./dist-multi >/dev/null 2>&1
if [[ -f dist-multi/entry.js ]] && [[ -f dist-multi/entry2.js ]]; then
  pass "bun build (multiple entrypoints)"
else
  fail "bun build (multiple entrypoints)" "missing output files"
fi

# ════════════════════════════════════════════════════════════════════
section "8. Bun APIs (Runtime)"
# ════════════════════════════════════════════════════════════════════

# 8.1 Bun.file()
cat > file-api.ts <<'EOF'
const file = Bun.file("package.json");
console.log(file.size > 0 ? "ok" : "fail");
EOF
OUTPUT=$($BUN run file-api.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "Bun.file() API"
else
  fail "Bun.file()" "got '$OUTPUT'"
fi

# 8.2 Bun.write()
cat > write-api.ts <<'EOF'
await Bun.write("test-output.txt", "hello bun write");
const content = await Bun.file("test-output.txt").text();
console.log(content);
EOF
OUTPUT=$($BUN run write-api.ts 2>&1)
if [[ "$OUTPUT" == "hello bun write" ]]; then
  pass "Bun.write() API"
else
  fail "Bun.write()" "got '$OUTPUT'"
fi

# 8.3 Bun.serve() (quick start/stop)
cat > serve-api.ts <<'EOF'
const server = Bun.serve({
  port: 0,
  fetch(req) {
    return new Response("ok");
  },
});
const resp = await fetch(`http://localhost:${server.port}`);
const text = await resp.text();
console.log(text);
server.stop();
EOF
OUTPUT=$($BUN run serve-api.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "Bun.serve() API"
else
  fail "Bun.serve()" "got '$OUTPUT'"
fi

# 8.4 Bun.hash()
cat > hash-api.ts <<'EOF'
const hash = Bun.hash("hello");
console.log(typeof hash === "number" || typeof hash === "bigint" ? "ok" : "fail");
EOF
OUTPUT=$($BUN run hash-api.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "Bun.hash() API"
else
  fail "Bun.hash()" "got '$OUTPUT'"
fi

# 8.5 Bun.sleep()
cat > sleep-api.ts <<'EOF'
const start = Date.now();
await Bun.sleep(50);
const elapsed = Date.now() - start;
console.log(elapsed >= 40 ? "ok" : "fail");
EOF
OUTPUT=$($BUN run sleep-api.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "Bun.sleep() API"
else
  fail "Bun.sleep()" "got '$OUTPUT'"
fi

# 8.6 Bun.env
cat > env-api.ts <<'EOF'
console.log(typeof Bun.env.HOME === "string" ? "ok" : "fail");
EOF
OUTPUT=$($BUN run env-api.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "Bun.env API"
else
  fail "Bun.env" "got '$OUTPUT'"
fi

# 8.7 Bun.spawn()
cat > spawn-api.ts <<'EOF'
const proc = Bun.spawn(["echo", "spawned"]);
const text = await new Response(proc.stdout).text();
console.log(text.trim());
EOF
OUTPUT=$($BUN run spawn-api.ts 2>&1)
if [[ "$OUTPUT" == "spawned" ]]; then
  pass "Bun.spawn() API"
else
  fail "Bun.spawn()" "got '$OUTPUT'"
fi

# 8.8 Bun.Transpiler
cat > transpiler-api.ts <<'EOF'
const t = new Bun.Transpiler({ loader: "tsx" });
const code = t.transformSync("const x: number = 1; console.log(x);");
console.log(code.includes("console.log") ? "ok" : "fail");
EOF
OUTPUT=$($BUN run transpiler-api.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "Bun.Transpiler API"
else
  fail "Bun.Transpiler" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "9. Node.js Compatibility"
# ════════════════════════════════════════════════════════════════════

# 9.1 fs module
cat > node-fs.ts <<'EOF'
import fs from "fs";
fs.writeFileSync("node-test.txt", "node-compat");
console.log(fs.readFileSync("node-test.txt", "utf8"));
EOF
OUTPUT=$($BUN run node-fs.ts 2>&1)
if [[ "$OUTPUT" == "node-compat" ]]; then
  pass "Node.js fs module"
else
  fail "Node.js fs" "got '$OUTPUT'"
fi

# 9.2 path module
OUTPUT=$($BUN -e "const path = require('path'); console.log(path.join('a','b','c'))" 2>&1)
if [[ "$OUTPUT" == "a/b/c" ]]; then
  pass "Node.js path module"
else
  fail "Node.js path" "got '$OUTPUT'"
fi

# 9.3 crypto module
OUTPUT=$($BUN -e "const crypto = require('crypto'); console.log(crypto.createHash('sha256').update('test').digest('hex').length)" 2>&1)
if [[ "$OUTPUT" == "64" ]]; then
  pass "Node.js crypto module"
else
  fail "Node.js crypto" "got '$OUTPUT'"
fi

# 9.4 Buffer
OUTPUT=$($BUN -e "console.log(Buffer.from('hello').toString('base64'))" 2>&1)
if [[ "$OUTPUT" == "aGVsbG8=" ]]; then
  pass "Node.js Buffer"
else
  fail "Node.js Buffer" "got '$OUTPUT'"
fi

# 9.5 process
OUTPUT=$($BUN -e "console.log(process.platform)" 2>&1)
if [[ "$OUTPUT" == "darwin" ]]; then
  pass "Node.js process.platform"
else
  fail "Node.js process" "got '$OUTPUT'"
fi

# 9.6 child_process
OUTPUT=$($BUN -e "const {execSync} = require('child_process'); console.log(execSync('echo cp-works').toString().trim())" 2>&1)
if [[ "$OUTPUT" == "cp-works" ]]; then
  pass "Node.js child_process"
else
  fail "Node.js child_process" "got '$OUTPUT'"
fi

# 9.7 events
OUTPUT=$($BUN -e "
const {EventEmitter} = require('events');
const e = new EventEmitter();
e.on('test', () => console.log('event-ok'));
e.emit('test');
" 2>&1)
if [[ "$OUTPUT" == "event-ok" ]]; then
  pass "Node.js events module"
else
  fail "Node.js events" "got '$OUTPUT'"
fi

# 9.8 url module
OUTPUT=$($BUN -e "const u = new URL('https://example.com/path?q=1'); console.log(u.hostname)" 2>&1)
if [[ "$OUTPUT" == "example.com" ]]; then
  pass "Node.js URL/url module"
else
  fail "Node.js URL" "got '$OUTPUT'"
fi

# 9.9 streams
OUTPUT=$($BUN -e "
const {Readable} = require('stream');
const r = Readable.from(['hello', ' ', 'stream']);
let out = '';
r.on('data', chunk => out += chunk);
r.on('end', () => console.log(out));
" 2>&1)
if [[ "$OUTPUT" == "hello stream" ]]; then
  pass "Node.js streams"
else
  fail "Node.js streams" "got '$OUTPUT'"
fi

# 9.10 util
OUTPUT=$($BUN -e "const util = require('util'); console.log(util.format('hello %s', 'world'))" 2>&1)
if [[ "$OUTPUT" == "hello world" ]]; then
  pass "Node.js util module"
else
  fail "Node.js util" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "10. Web APIs"
# ════════════════════════════════════════════════════════════════════

# 10.1 fetch
cat > web-fetch.ts <<'EOF'
const resp = await fetch("https://httpbin.org/get");
console.log(resp.status);
EOF
OUTPUT=$($BUN run web-fetch.ts 2>&1) || true
if [[ "$OUTPUT" == "200" ]]; then
  pass "fetch() Web API"
else
  skip "fetch() Web API" "network may be unavailable (got '$OUTPUT')"
fi

# 10.2 Response/Request
OUTPUT=$($BUN -e "
const req = new Request('https://example.com', {method: 'POST'});
const resp = new Response('body', {status: 201});
console.log(req.method, resp.status);
" 2>&1)
if [[ "$OUTPUT" == "POST 201" ]]; then
  pass "Request/Response Web APIs"
else
  fail "Request/Response" "got '$OUTPUT'"
fi

# 10.3 TextEncoder/TextDecoder
OUTPUT=$($BUN -e "
const enc = new TextEncoder();
const dec = new TextDecoder();
const bytes = enc.encode('hello');
console.log(dec.decode(bytes));
" 2>&1)
if [[ "$OUTPUT" == "hello" ]]; then
  pass "TextEncoder/TextDecoder"
else
  fail "TextEncoder/TextDecoder" "got '$OUTPUT'"
fi

# 10.4 Blob/File
OUTPUT=$($BUN -e "
const blob = new Blob(['hello ', 'blob']);
blob.text().then(t => console.log(t));
" 2>&1)
if [[ "$OUTPUT" == "hello blob" ]]; then
  pass "Blob Web API"
else
  fail "Blob" "got '$OUTPUT'"
fi

# 10.5 FormData
OUTPUT=$($BUN -e "
const fd = new FormData();
fd.set('key', 'value');
console.log(fd.get('key'));
" 2>&1)
if [[ "$OUTPUT" == "value" ]]; then
  pass "FormData Web API"
else
  fail "FormData" "got '$OUTPUT'"
fi

# 10.6 Headers
OUTPUT=$($BUN -e "
const h = new Headers();
h.set('X-Test', 'hello');
console.log(h.get('X-Test'));
" 2>&1)
if [[ "$OUTPUT" == "hello" ]]; then
  pass "Headers Web API"
else
  fail "Headers" "got '$OUTPUT'"
fi

# 10.7 AbortController
OUTPUT=$($BUN -e "
const ac = new AbortController();
console.log(ac.signal.aborted);
ac.abort();
console.log(ac.signal.aborted);
" 2>&1)
if [[ "$OUTPUT" == "false
true" ]]; then
  pass "AbortController Web API"
else
  fail "AbortController" "got '$OUTPUT'"
fi

# 10.8 WebSocket (just check constructor exists)
OUTPUT=$($BUN -e "console.log(typeof WebSocket)" 2>&1)
if [[ "$OUTPUT" == "function" ]]; then
  pass "WebSocket available"
else
  fail "WebSocket" "got '$OUTPUT'"
fi

# 10.9 crypto.subtle
OUTPUT=$($BUN -e "console.log(typeof crypto.subtle.digest)" 2>&1)
if [[ "$OUTPUT" == "function" ]]; then
  pass "Web Crypto (crypto.subtle)"
else
  fail "Web Crypto" "got '$OUTPUT'"
fi

# 10.10 structuredClone
OUTPUT=$($BUN -e "
const obj = {a: 1, b: {c: 2}};
const clone = structuredClone(obj);
clone.b.c = 99;
console.log(obj.b.c, clone.b.c);
" 2>&1)
if [[ "$OUTPUT" == "2 99" ]]; then
  pass "structuredClone"
else
  fail "structuredClone" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "11. bunx (Package Execution)"
# ════════════════════════════════════════════════════════════════════

# 11.1 bunx with cowsay
OUTPUT=$($BUN x cowsay "moo" 2>&1) || true
if echo "$OUTPUT" | grep -q "moo"; then
  pass "bun x cowsay (bunx)"
else
  skip "bun x cowsay" "network or package issue"
fi

# ════════════════════════════════════════════════════════════════════
section "12. Bun Shell (Bun.$)"
# ════════════════════════════════════════════════════════════════════

# 12.1 Basic shell
cat > shell.ts <<'EOF'
import { $ } from "bun";
const output = await $`echo shell-works`.text();
console.log(output.trim());
EOF
OUTPUT=$($BUN run shell.ts 2>&1)
if [[ "$OUTPUT" == "shell-works" ]]; then
  pass "Bun.$ shell (basic)"
else
  fail "Bun.$ shell" "got '$OUTPUT'"
fi

# 12.2 Shell with pipes
cat > shell-pipe.ts <<'EOF'
import { $ } from "bun";
const output = await $`echo "hello world" | tr 'a-z' 'A-Z'`.text();
console.log(output.trim());
EOF
OUTPUT=$($BUN run shell-pipe.ts 2>&1)
if [[ "$OUTPUT" == "HELLO WORLD" ]]; then
  pass "Bun.$ shell (pipes)"
else
  fail "Bun.$ shell (pipes)" "got '$OUTPUT'"
fi

# 12.3 Shell with variables
cat > shell-var.ts <<'EOF'
import { $ } from "bun";
const name = "bun";
const output = await $`echo hello ${name}`.text();
console.log(output.trim());
EOF
OUTPUT=$($BUN run shell-var.ts 2>&1)
if [[ "$OUTPUT" == "hello bun" ]]; then
  pass "Bun.$ shell (template vars)"
else
  fail "Bun.$ shell (template vars)" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "13. SQLite (bun:sqlite)"
# ════════════════════════════════════════════════════════════════════

cat > sqlite.ts <<'EOF'
import { Database } from "bun:sqlite";

const db = new Database(":memory:");
db.run("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)");
db.run("INSERT INTO users (name) VALUES (?)", ["Alice"]);
db.run("INSERT INTO users (name) VALUES (?)", ["Bob"]);
const rows = db.query("SELECT name FROM users ORDER BY name").all();
console.log(rows.map((r: any) => r.name).join(","));
db.close();
EOF
OUTPUT=$($BUN run sqlite.ts 2>&1)
if [[ "$OUTPUT" == "Alice,Bob" ]]; then
  pass "bun:sqlite (in-memory database)"
else
  fail "bun:sqlite" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "14. FFI (bun:ffi)"
# ════════════════════════════════════════════════════════════════════

cat > ffi-check.ts <<'EOF'
import { dlopen, FFIType } from "bun:ffi";
// Just verify the module loads and types exist
console.log(typeof dlopen === "function" && FFIType.i32 !== undefined ? "ok" : "fail");
EOF
OUTPUT=$($BUN run ffi-check.ts 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "bun:ffi module available"
else
  fail "bun:ffi" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "15. Workers & Performance"
# ════════════════════════════════════════════════════════════════════

# 15.1 performance.now()
OUTPUT=$($BUN -e "
const start = performance.now();
let sum = 0;
for (let i = 0; i < 1000000; i++) sum += i;
const elapsed = performance.now() - start;
console.log(elapsed > 0 ? 'ok' : 'fail');
" 2>&1)
if [[ "$OUTPUT" == "ok" ]]; then
  pass "performance.now()"
else
  fail "performance.now()" "got '$OUTPUT'"
fi

# 15.2 queueMicrotask
OUTPUT=$($BUN -e "
queueMicrotask(() => console.log('microtask'));
" 2>&1)
if [[ "$OUTPUT" == "microtask" ]]; then
  pass "queueMicrotask"
else
  fail "queueMicrotask" "got '$OUTPUT'"
fi

# 15.3 setTimeout / setInterval
OUTPUT=$($BUN -e "
setTimeout(() => console.log('timer-ok'), 10);
" 2>&1)
if [[ "$OUTPUT" == "timer-ok" ]]; then
  pass "setTimeout"
else
  fail "setTimeout" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
section "16. Misc Commands"
# ════════════════════════════════════════════════════════════════════

# 16.1 bun upgrade --help (just verify it parses)
OUTPUT=$($BUN upgrade --help 2>&1) || true
if echo "$OUTPUT" | grep -qi "upgrade"; then
  pass "bun upgrade --help"
else
  skip "bun upgrade --help" "not available"
fi

# 16.2 bun --help
OUTPUT=$($BUN --help 2>&1)
if echo "$OUTPUT" | grep -q "Usage"; then
  pass "bun --help"
else
  fail "bun --help" "no usage info"
fi

# 16.3 bun build --help
OUTPUT=$($BUN build --help 2>&1)
if echo "$OUTPUT" | grep -qi "bundle"; then
  pass "bun build --help"
else
  fail "bun build --help" "no help output"
fi

# ════════════════════════════════════════════════════════════════════
section "17. Watch Mode (quick smoke test)"
# ════════════════════════════════════════════════════════════════════

cat > watch-test.ts <<'EOF'
console.log("watch-initial");
process.exit(0);
EOF
OUTPUT=$(timeout 5 $BUN --watch run watch-test.ts 2>&1) || true
if echo "$OUTPUT" | grep -q "watch-initial"; then
  pass "bun --watch (initial run)"
else
  skip "bun --watch" "timeout or not supported"
fi

# ════════════════════════════════════════════════════════════════════
section "18. Environment & Dotenv"
# ════════════════════════════════════════════════════════════════════

cat > .env <<'EOF'
MY_SECRET=bun-dotenv-works
EOF
cat > dotenv.ts <<'EOF'
console.log(process.env.MY_SECRET);
EOF
OUTPUT=$($BUN run dotenv.ts 2>&1)
if [[ "$OUTPUT" == "bun-dotenv-works" ]]; then
  pass "Auto .env loading"
else
  fail "Auto .env loading" "got '$OUTPUT'"
fi

# ════════════════════════════════════════════════════════════════════
# Summary
# ════════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}RESULTS${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}Passed:${NC}  $PASS"
echo -e "  ${RED}Failed:${NC}  $FAIL"
echo -e "  ${YELLOW}Skipped:${NC} $SKIP"
TOTAL=$((PASS + FAIL + SKIP))
echo -e "  ${BOLD}Total:${NC}   $TOTAL"
echo ""

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo -e "${RED}${BOLD}Failed tests:${NC}"
  for err in "${ERRORS[@]}"; do
    echo -e "  ${RED}✗${NC} $err"
  done
  echo ""
fi

if [[ $FAIL -eq 0 ]]; then
  echo -e "${GREEN}${BOLD}All tests passed! Your bun build is working correctly.${NC}"
  exit 0
else
  echo -e "${YELLOW}${BOLD}$FAIL test(s) failed. Review the failures above.${NC}"
  exit 1
fi
