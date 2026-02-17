# 🧾 Nakushi Input Contract (v1)

Nakushi is a file-system based state machine.
AI agents MUST treat repository files as the source of truth.

This contract standardizes **how an incubation receives input** so any AI (ChatGPT, Claude, Copilot, etc.)
can reliably determine the current stage and propose next artifacts.

---

## 1) Canonical Inputs (per incubation)

Each incubation directory `/incubations/<name>/` MAY contain:

### A) `raw-plan.md` (preferred)
- The original planning document authored by the user.
- Can be long, unstructured, and contain brainstorming.
- AI agents MUST read this file if it exists, and use it as the primary input source.

### B) `input.md` (optional)
- A normalized, AI-friendly version distilled from `raw-plan.md`.
- If `input.md` exists, AI agents SHOULD prefer it over `raw-plan.md` for generating outputs
  (but must keep `raw-plan.md` as reference).

> Rule: `raw-plan.md` is the canonical "human truth". `input.md` is the canonical "AI working truth" (optional).

---

## 2) Required Outputs (stage dependent)

AI agents MUST generate outputs into these standard locations:

- `stage.md`
- `problem.md`
- `mvp-scope.md`
- `experiment-notes.md`
- (later) `implementation-plan.md`
- (later) `vertical-slice-01.md`

Templates live at:
- `/incubations/_template/*`
- `/ops/templates/*`

---

## 3) Scaffold-First Rule (hard rule)

Before any stage evaluation, AI agents MUST ensure:

- `/incubations/<name>/stage.md` exists
- If missing → create it from `/incubations/_template/stage.md` and initialize stage based on file existence

---

## 4) IDE-first Usage (Copilot / JetBrains / Claude Code)

To use Nakushi inside an IDE:

1) Create or paste your plan into `/incubations/<name>/raw-plan.md`
2) Ask the AI agent to run "Next Step Planner" using:
   - `/prompts/nakushi-next-step.md`
3) Approve the proposed artifacts.
4) Let the agent generate drafts from templates.

The repo itself contains all instructions needed.

---

## 5) Minimal Compliance Checklist

For a new incubation to be AI-operable:

- [ ] `/incubations/<name>/raw-plan.md` exists (or `input.md`)
- [ ] `/incubations/<name>/stage.md` exists (or can be scaffolded)
- [ ] `/ops/stage-map.md` exists
- [ ] `/ops/playbook.md` exists
- [ ] `/prompts/nakushi-next-step.md` exists

