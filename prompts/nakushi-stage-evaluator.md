# Prompt — Stage Evaluator (v2: evidence-based)

Given the Nakushi repository state:

- Read /ops/stage-map.md
- For each incubation under /incubations/* (excluding _template), read stage.md and all required files for its declared CURRENT_STAGE
- For each exit-criteria bullet at CURRENT_STAGE, quote the specific line/section from the relevant file that satisfies it. A required file existing with no quotable evidence means that criterion is NOT met, even if the file's checkbox is ticked in stage.md.
- Validate whether required files exist AND whether exit criteria is met (evidence-based, not presence-based)
- Produce a report listing:
  - incubation name
  - current stage validity (OK / Missing / Inconsistent) — mark Inconsistent if stage.md claims a stage that the evidence doesn't support
  - unmet exit criteria (with what's missing, not just "file missing")
  - next recommended artifacts (top 3)

Keep it concise and action-oriented.
