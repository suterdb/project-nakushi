# 🧭 Nakushi Stage Map (Global)

This document defines the universal stages for any incubation under `/incubations/*`.

## How to use
1. Each incubation MUST have `/incubations/<name>/stage.md`.
2. `stage.md` declares CURRENT_STAGE and "next required artifacts".
3. AI agents should:
   - read this stage map
   - read the incubation's `stage.md`
   - verify required files exist
   - **verify exit criteria with evidence** — for each exit criterion bullet, quote the specific line/section in the file that satisfies it. "File exists" is not evidence; a criterion with no supporting quote is NOT met.
   - propose the next artifacts in order
   - create drafts only after user approval (unless configured otherwise)

### Exit criteria are content checks, not file-existence checks
A stage's required files can all exist and the stage can still be invalid, if the content doesn't actually satisfy the exit criteria (e.g. `mvp-scope.md` exists but lists 5 core flows, not <=3). When evaluating CURRENT_STAGE, treat each exit-criteria bullet as a yes/no question and record the evidence in `stage.md` (see template). Do not advance CURRENT_STAGE on file presence alone.

---

## Stage 00 — Problem Defined
**Objective:** crystalize the problem and target user.

**Required (in `/incubations/<name>/`):**
- `problem.md`

**Exit criteria:**
- problem statement fits within 1 page
- success definition exists (what would prove this is worth building)

**Next artifacts:**
- `mvp-scope.md`
- `experiment-notes.md`
- `stage.md` (if missing)

---

## Stage 10 — MVP Defined
**Objective:** define the smallest product that can validate the key hypothesis.

**Required:**
- `problem.md`
- `mvp-scope.md`
- `experiment-notes.md`
- `stage.md`

**Exit criteria:**
- MVP scope <= 3 core flows (input → store → output)
- out-of-scope list exists
- validation criteria is measurable

**Next artifacts:**
- ADR set (Tech Baseline)
  - `/ops/decisions/ADR-XXX-tech-stack.md`
  - `/ops/decisions/ADR-XXX-architecture.md`
  - `/ops/decisions/ADR-XXX-data-model.md`
  - `/ops/decisions/ADR-XXX-deployment.md`

---

## Stage 20 — Technical Baseline Fixed
**Objective:** remove technical ambiguity before coding.

**Required:**
- Stage 10 artifacts
- Tech Baseline ADR set (at least stack + architecture + data-model)

**Exit criteria:**
- chosen stack is explicit
- rollback notes exist for risky decisions
- MVP has a minimal deploy plan

**Next artifacts:**
- `spec.md` — synthesizes `problem.md` + `mvp-scope.md` + the ADR set into a single consolidated reference: screen list, API list, data model summary, out-of-scope. Written BEFORE `implementation-plan.md`; the plan derives from `spec.md` rather than re-deriving from scattered files.
- `implementation-plan.md`
- `vertical-slice-01.md`
- GitHub Issues breakdown (8–12)

---

## Stage 30 — Execution Ready
**Objective:** translate plans into executable tasks.

**Required:**
- Stage 20 artifacts
- `spec.md`
- `implementation-plan.md`
- `vertical-slice-01.md`

**Exit criteria:**
- `spec.md` exists and covers screen list, API list, and data model summary (not just a stub)
- `implementation-plan.md` traces back to `spec.md` (no undocumented screens/APIs invented mid-plan)
- vertical slice can be built in 1–3 days
- issue list exists and maps to plan

**Next artifacts:**
- `/ops/reports/YYYY-W##.md` (start weekly cadence)
- first vertical slice merged

---

## Stage 40 — Active Build
**Objective:** iterate by weekly reports + ADRs as decisions happen.

**Required:**
- at least one weekly report
- at least one merged vertical slice

**Exit criteria:**
- validation executed (real users or proxy tests)
- decision made: spin-off, continue, or archive

**Next artifacts:**
- spin-off plan OR archive note

---

## Stage 90 — Archived / Spun-off
**Objective:** the incubation is concluded.

**Required:**
- `archive.md` OR a link to new repo (spin-off)

