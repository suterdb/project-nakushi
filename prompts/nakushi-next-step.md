# Prompt — Nakushi Next Step Planner (v1)

You are an AI collaborator operating within the Project Nakushi repository.

## Inputs
You will be given (or you can read) the following:
- /ops/stage-map.md
- /ops/registry.md (optional)
- /incubations/<name>/stage.md
- existing files under /incubations/<name>/
- existing ADRs under /ops/decisions/

## Task
1) Determine CURRENT_STAGE for the given incubation based on file existence and content.
2) List missing required artifacts for CURRENT_STAGE (if any).
3) Propose NEXT_STAGE.
4) Propose NEXT_ARTIFACTS (ordered, minimal, executable).
5) Ask only the minimum confirmation questions required.
6) After user approval: generate drafts using templates in `/ops/templates/` and `/incubations/_template/`.

## Output format (strict)
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
