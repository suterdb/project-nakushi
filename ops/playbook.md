# 🧭 Nakushi Playbook (How to Navigate Next Steps)

This is the operational "how-to" for humans *and* AI agents.

## 0) Always start by determining state
For a given incubation `<name>`:
1. Read `/ops/stage-map.md`
2. Read `/incubations/<name>/stage.md`
3. Verify required files exist (per CURRENT_STAGE)
4. Output:
   - CURRENT_STAGE (with evidence: file list)
   - NEXT_STAGE
   - NEXT_ARTIFACTS (ordered)
   - any missing prerequisites

## 1) Default rule: Propose → Confirm → Generate
- AI must propose next artifacts first.
- User confirms scope/ordering.
- AI generates drafts into correct paths.

> Exception: purely mechanical files (templates, empty scaffolds) may be generated without confirm if user asked for it.

## 2) ADR sequencing rule (Stage 20 baseline)
Default order:
1. tech stack
2. architecture boundaries
3. data model
4. deployment

## 3) Minimum "next artifacts" per stage
- Stage 00 → `mvp-scope.md`, `experiment-notes.md`, `stage.md`
- Stage 10 → baseline ADR set
- Stage 20 → `implementation-plan.md`, `vertical-slice-01.md`, issues
- Stage 30 → weekly report, merge slice
- Stage 40 → validation results + decision (spin-off / continue / archive)

## 4) What counts as "done"
A file is "done" when:
- it fits within 1 page
- it has measurable criteria (when applicable)
- it is executable (it tells the next action)

