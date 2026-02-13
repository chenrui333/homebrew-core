# Master Roadmap

## Goal

Deliver a Bun 1.3.8 formula branch that is:

1. Reproducibly source-buildable in Homebrew constraints.
2. Significantly lower patch surface than current state.
3. Maintainable for future upgrades.
4. Ready for upstream submission discussion/issues.

## Current Baseline

- Branch: `bun-1.3.8`
- Source build: passing in local environment.
- Formula complexity: high (`inreplace` count and iterative compatibility patches).
- Loop detector noise: recently reduced, but needs final verification in phase validation.

## Strategy

### Track A: Stabilize + Revalidate
Freeze behavior and establish a trusted baseline with strict reproducibility checks.

### Track B: Patch Surface Reduction
Systematically remove or consolidate patches while preserving build/test pass.

### Track C: Maintainability Refactor
Group and document unavoidable compatibility patches by subsystem.

### Track D: Upstream/Long-term
Prepare issue bundles and candidate upstream fixes to reduce local carry.

## Risk Model

- Highest risk: ABI/layout mismatches with prebuilt WebKit/JSC headers.
- High risk: OpenSSL3/BoringSSL compatibility shims introducing runtime regressions.
- Medium risk: Toolchain-specific strip/dsymutil behavior on macOS.
- Medium risk: false-positive loop/network detections masking real failures.

## Exit Criteria (Submission Candidate)

- `brew install --build-from-source bun` passes from clean state.
- `brew test bun` passes.
- `brew audit --strict bun` passes.
- `brew style bun` passes.
- Patch list reduced and grouped with rationale comments.
- Upstream issue draft set prepared for non-Homebrew-owned breakpoints.
