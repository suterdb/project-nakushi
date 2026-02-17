# Prompt Overlay — Nakushi Input Contract Rules (v1)

Add the following section into `/prompts/nakushi-next-step.md` under the rules section:

## Input Contract (hard rule)
- Treat `/incubations/<name>/raw-plan.md` as the canonical input if it exists.
- If `/incubations/<name>/input.md` exists, prefer it for generation, and use `raw-plan.md` for reference.
- If neither exists, ask the user to provide at least one of them before proceeding with generation.

