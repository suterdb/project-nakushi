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
1) Determine CURRENT_STAGE for the given incubation based on file existence AND content (light check).
2) List missing required artifacts for CURRENT_STAGE (if any).
3) Propose NEXT_STAGE.
4) Propose NEXT_ARTIFACTS (ordered, minimal, executable).
5) Ask only the minimum confirmation questions required.
6) After user approval: generate drafts using templates in `/ops/templates/` and `/incubations/_template/`.

## Output format (strict)
SCAFFOLDING:
- performed: yes/no
- created: (path) if yes
CURRENT_STAGE: ...
EVIDENCE:
- file: ... (why it satisfies requirement)
MISSING:
- ...
NEXT_STAGE: ...
NEXT_ARTIFACTS (ordered):
1) path: ... — purpose: ...
2) ...
QUESTIONS (if needed):
- ...
