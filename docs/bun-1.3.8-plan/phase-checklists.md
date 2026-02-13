# Phase Checklists

## Phase 0: Baseline Lock

### Objective
Create a clean, reproducible, documented baseline before any minimization.

### Steps
1. Clean workspace artifacts that should not ship in PR.
2. Run full baseline validation from clean state.
3. Capture exact command outputs and timing in notes.
4. Tag/mark baseline commit.

### Validation Commands
1. `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source Formula/b/bun.rb`
2. `brew test bun`
3. `brew audit --strict bun`
4. `brew style Formula/b/bun.rb`

### Check-in Gate
- All 4 commands pass in sequence.
- No pending unrelated diffs.
- Baseline commit message includes validation summary.

---

## Phase 1: Patch Inventory and Classification

### Objective
Classify every patch/inreplace by necessity and owner.

### Steps
1. Export all patch points from `Formula/b/bun.rb`.
2. Classify each as:
   - `required-now`
   - `candidate-remove`
   - `candidate-consolidate`
   - `upstream-bug`
3. Group by subsystem:
   - WebKit/JSC ABI/header
   - OpenSSL3/BoringSSL
   - CMake/build tooling
   - Runtime stubs
   - loop tooling
4. Record rationale in a tracking table.

### Deliverable
- A tracked inventory doc/table with owner and risk score.

### Check-in Gate
- 100% of current patch points classified.
- Top 10 highest-risk patch points identified.

---

## Phase 2: Low-Risk Patch Reduction

### Objective
Remove/consolidate low-risk patches with fast feedback loops.

### Steps
1. Remove one low-risk patch cluster at a time.
2. Re-run targeted build stage / quick compile checks.
3. If pass, proceed; if fail, revert that cluster and mark as required.
4. Combine duplicate `inreplace` edits on same file where possible.

### Validation (per cluster)
1. `brew style Formula/b/bun.rb`
2. `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source Formula/b/bun.rb`
3. `brew test bun`

### Check-in Gate
- Net reduction in patch count.
- No regression in baseline validation.

---

## Phase 3: Medium/High-Risk Rationalization

### Objective
Contain unavoidable complex patches and make them maintainable.

### Steps
1. Consolidate related edits into clearly separated blocks in formula.
2. Add short rationale comments for non-obvious compatibility patches.
3. Ensure order-dependence is explicit (header copy/ABI/shim sequencing).
4. Convert ad-hoc edits into deterministic, minimal transformations.

### Validation
- Full baseline validation sequence.
- Run at least one clean rebuild after cleanup.

### Check-in Gate
- Complex patches are grouped and documented.
- Formula readability materially improved.

---

## Phase 4: Test and Quality Expansion

### Objective
Improve confidence in behavior, not just compilation.

### Steps
1. Strengthen `test do` in formula for functional execution path.
2. Add one additional smoke assertion beyond version output.
3. Verify crash-free basic script execution path.
4. Re-run audit/style.

### Validation
1. `brew test bun`
2. smoke test command output from installed binary.
3. `brew audit --strict bun`

### Check-in Gate
- Tests cover at least one runtime behavior path.
- No known crash in minimal script path.

---

## Phase 5: Upstream Preparation

### Objective
Prepare clean, actionable upstream issue batches.

### Steps
1. Convert classified `upstream-bug` items into issue-ready entries.
2. Include minimal repro + expected/actual behavior.
3. Link local workaround commit references.
4. Mark blockers vs nice-to-have.

### Check-in Gate
- Issue draft set complete and prioritized.
- Local workarounds clearly mapped to upstream items.

---

## Phase 6: PR Assembly and Hygiene

### Objective
Turn branch into reviewable PR-quality history.

### Steps
1. Collapse iterative commits into logical commits.
2. Remove transient artifacts (ralph handoff scratch outputs etc.).
3. Prepare concise PR description with local validation summary.
4. Final full validation run.

### Final Gate
- Clean commit history.
- Validation commands all green.
- Diff focused to bun formula/tooling only.
