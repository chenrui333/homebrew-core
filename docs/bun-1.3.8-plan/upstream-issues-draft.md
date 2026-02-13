# Upstream Issues Draft (Working)

This file is a staging area before opening upstream issues.

## Batch 1: OpenSSL 3 Compatibility

### Candidate topics
- BoringSSL-only headers/functions usage in Bun source paths.
- OpenSSL 3 API const-correctness differences.
- Deprecated API warnings treated as errors in current toolchain.

### Template
- Context: Bun v1.3.8 source build in Homebrew environment.
- Repro: exact file + compile error.
- Expected: builds with OpenSSL3 without local shim patch.
- Actual: compile/link failure.
- Local workaround: commit hash + patch summary.

## Batch 2: WebKit/JSC Header/ABI Assumptions

### Candidate topics
- Reliance on private headers/layout assumptions in mixed build contexts.
- Missing generated/private header exposure assumptions.
- TZone allocation macro impl gaps for specific classes.

## Batch 3: Build Toolchain Portability

### Candidate topics
- GNU strip flags used on macOS toolchain.
- dsymutil invocation assumptions.
- CMake install target absent/empty install behavior.

## Batch 4: Runtime/Inspector Optionality

### Candidate topics
- Remote inspector symbol availability assumptions.
- Optional component linkage/stub strategy.

## Notes

- Only file upstream issues for behaviors reproducible without Homebrew-only modifications when possible.
- Keep each issue narrowly scoped and attach minimal diff/repro.
