# Prompt — Nakushi Next Step Planner (v2: scaffold-first)

You are an AI collaborator operating within the Project Nakushi repository.

## Inputs
You will be given (or you can read) the following:
- /ops/stage-map.md
- /ops/playbook.md
- /ops/registry.md (optional)
- /incubations/<name>/ (the incubation directory)
- existing ADRs under /ops/decisions/
- templates under:
  - /ops/templates/
  - /incubations/_template/

## Hard rule: scaffold before evaluate
If `/incubations/<name>/stage.md` is missing, you MUST scaffold it BEFORE any stage evaluation.

Scaffolding steps:
1) Copy `/incubations/_template/stage.md` to `/incubations/<name>/stage.md`
2) Replace `<INCUBATION_NAME>` with `<name>`
3) Initialize CURRENT_STAGE based on existing files:
   - if `problem.md` missing → Stage 00 — Problem Defined
   - else if `mvp-scope.md` missing OR `experiment-notes.md` missing → Stage 10 — MVP Defined (incomplete)
   - else → Stage 10 — MVP Defined
4) Set NEXT_STAGE accordingly
5) Set Last updated to today's date (YYYY-MM-DD)

After scaffolding, proceed.

## Task
1) Determine CURRENT_STAGE for the given incubation. For each exit-criteria bullet at the candidate stage (per `/ops/stage-map.md`), quote the specific line/section that satisfies it. A required file existing with no quotable evidence means that criterion is NOT met — do not credit the stage for it.
2) List missing required artifacts for CURRENT_STAGE, AND list any exit criteria that are unmet despite the file existing (if any).
3) Propose NEXT_STAGE.
4) Propose NEXT_ARTIFACTS (ordered, minimal, executable). At Stage 20, `spec.md` comes first — it synthesizes problem/mvp-scope/ADR before `implementation-plan.md` is written.
5) Ask only the minimum confirmation questions required.
6) After user approval: generate drafts using templates in `/ops/templates/` and `/incubations/_template/`.

## Output format (strict)
SCAFFOLDING:
- performed: yes/no
- created: (path) if yes
CURRENT_STAGE: ...
EVIDENCE (one line per exit-criteria bullet, quoted — not a bare file list):
- criterion: ... — quote: "..." (file: path)
MISSING:
- (files missing, and/or exit criteria unmet despite the file existing)
NEXT_STAGE: ...
NEXT_ARTIFACTS (ordered):
1) path: ... — purpose: ...
2) ...
QUESTIONS (if needed):
- ...
