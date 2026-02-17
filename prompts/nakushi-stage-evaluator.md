# Prompt — Stage Evaluator (v1)

Given the Nakushi repository state:

- Read /ops/stage-map.md
- For each incubation under /incubations/* (excluding _template), read stage.md
- Validate whether required files exist and whether exit criteria is met
- Produce a report listing:
  - incubation name
  - current stage validity (OK / Missing / Inconsistent)
  - next recommended artifacts (top 3)

Keep it concise and action-oriented.
