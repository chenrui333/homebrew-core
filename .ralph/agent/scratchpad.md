
## 2026-02-11T18:12:06Z
- Context: New iteration for Bun 1.3.8 source-build orchestration in homebrew-core.
- Plan: create one runtime task, run tools/bun_loop.sh, inspect newest summary, patch only first failure cause with minimal/surgical change (prefer Formula/b/bun.rb), rerun loop for verification, then commit and close task.
