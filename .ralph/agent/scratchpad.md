# Bun v1.3.8 Source Build - Bootstrap Enabled

## Current Status: IN PROGRESS

Bootstrap binary now allowed (like Rust/Go pattern). Ready for next build iteration.

## Key Change (2026-02-11T22:15)

Removed `BUN_BOOTSTRAP=OFF` to allow the bootstrap bun binary download for codegen.
This follows the same pattern as:
- **Rust**: needs rustc to build rustc
- **Go**: needs go to build go
- **OCaml**: needs ocaml to build ocaml

## Progress Made

Successfully patched/vendored:
- ✅ System zig support (USE_SYSTEM_ZIG=ON)
- ✅ System deps: brotli, c-ares, highway, libdeflate, lol-html, mimalloc, zlib, zstd, libarchive, hdrhistogram_c, libuv, sqlite, boringssl
- ✅ Vendored: picohttpparser, ls-hpack, nodejs-headers
- ✅ Zig 0.15.x compatibility (@hasField guard for no_link_obj)
- ✅ CMake 4 policy for lshpack
- ✅ esbuild external peechy/preact patches
- ✅ Bootstrap re-enabled for codegen

## Next Steps

1. Run `tools/bun_loop.sh` to test with bootstrap enabled
2. Fix any remaining compile errors
3. Validate successful build and test

## Allowed Network Activity
- Bootstrap bun binary download (for codegen)
- Bootstrap zig download (if USE_SYSTEM_ZIG doesn't work)

## Blocked Network Activity
- npm/bun install for JS dependencies
- git clone for C/C++ dependencies
- Arbitrary URL fetches for headers/sources
