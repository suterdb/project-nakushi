\
#!/usr/bin/env bash
set -euo pipefail

# Nakushi: initialize an incubation folder via template AND open a PR-ready branch.
#
# Usage:
#   scripts/nakushi-init-incubation.sh <name> [base_branch] [remote]
#
# Examples:
#   scripts/nakushi-init-incubation.sh linet
#   scripts/nakushi-init-incubation.sh linet main origin

NAME="${1:-}"
BASE_BRANCH="${2:-main}"
REMOTE="${3:-origin}"

if [[ -z "$NAME" ]]; then
  echo "Usage: $0 <name> [base_branch] [remote]"
  exit 1
fi

TEMPLATE_DIR="incubations/_template"
TARGET_DIR="incubations/${NAME}"
BRANCH="inc/${NAME}-bootstrap"

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "ERROR: template directory not found: $TEMPLATE_DIR"
  exit 1
fi

# Ensure clean working tree
if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: working tree is not clean. Commit or stash changes first."
  exit 1
fi

# Fetch latest base branch
git fetch "$REMOTE" "$BASE_BRANCH" >/dev/null 2>&1 || true

# Create branch
git checkout "$BASE_BRANCH" >/dev/null 2>&1
git pull "$REMOTE" "$BASE_BRANCH" >/dev/null 2>&1 || true
git checkout -b "$BRANCH"

# Scaffold incubation directory
if [[ -d "$TARGET_DIR" ]]; then
  echo "INFO: $TARGET_DIR already exists. Will not overwrite existing files."
else
  mkdir -p "$TARGET_DIR"
  # Copy template files
  cp -R "${TEMPLATE_DIR}/." "$TARGET_DIR/"
fi

# Ensure stage.md exists (create if missing)
if [[ ! -f "${TARGET_DIR}/stage.md" ]]; then
  cp "${TEMPLATE_DIR}/stage.md" "${TARGET_DIR}/stage.md"
fi

# Replace placeholder tokens
# macOS/BSD sed differs; use a portable approach
python3 - <<'PY'
import os, re, sys, datetime
name = os.environ["NAME"]
target_dir = os.environ["TARGET_DIR"]
today = datetime.date.today().isoformat()

def replace_in_file(path: str):
    with open(path, "r", encoding="utf-8") as f:
        s = f.read()
    s2 = s.replace("<INCUBATION_NAME>", name)
    # Update last updated line if present
    s2 = re.sub(r"(?m)^- \d{4}-\d{2}-\d{2}\s*$", f"- {today}", s2)
    with open(path, "w", encoding="utf-8") as f:
        f.write(s2)

for root, _, files in os.walk(target_dir):
    for fn in files:
        if fn.endswith(".md"):
            replace_in_file(os.path.join(root, fn))
PY
# pass env to python
NAME="$NAME" TARGET_DIR="$TARGET_DIR" python3 -c "pass" >/dev/null 2>&1 || true

# Initialize CURRENT_STAGE based on file presence
PROBLEM="${TARGET_DIR}/problem.md"
MVP="${TARGET_DIR}/mvp-scope.md"
NOTES="${TARGET_DIR}/experiment-notes.md"
STAGE="${TARGET_DIR}/stage.md"

python3 - <<'PY'
import os, re, datetime
target_dir = os.environ["TARGET_DIR"]
problem = os.path.join(target_dir, "problem.md")
mvp = os.path.join(target_dir, "mvp-scope.md")
notes = os.path.join(target_dir, "experiment-notes.md")
stage = os.path.join(target_dir, "stage.md")
today = datetime.date.today().isoformat()

if not os.path.exists(problem):
    current = "Stage 00 — Problem Defined"
    nexts = "Stage 10 — MVP Defined"
    required = ["- [ ] problem.md"]
    next_artifacts = ["- [ ] mvp-scope.md", "- [ ] experiment-notes.md"]
else:
    current = "Stage 10 — MVP Defined"
    nexts = "Stage 20 — Technical Baseline Fixed"
    required = ["- [x] problem.md",
                "- [ ] mvp-scope.md" if not os.path.exists(mvp) else "- [x] mvp-scope.md",
                "- [ ] experiment-notes.md" if not os.path.exists(notes) else "- [x] experiment-notes.md"]
    next_artifacts = [
        "- [ ] /ops/decisions/ADR-XXX-tech-stack.md",
        "- [ ] /ops/decisions/ADR-XXX-architecture.md",
        "- [ ] /ops/decisions/ADR-XXX-data-model.md",
        "- [ ] /ops/decisions/ADR-XXX-deployment.md",
    ]

with open(stage, "r", encoding="utf-8") as f:
    s = f.read()

s = re.sub(r"(?m)^CURRENT_STAGE:.*$", f"CURRENT_STAGE: {current}", s)
s = re.sub(r"(?m)^NEXT_STAGE:.*$", f"NEXT_STAGE: {nexts}", s)

# Replace required section block (best-effort)
s = re.sub(r"(?s)(## Required files \(per current stage\)\n)(.*?)(\n## Next artifacts)",
           lambda m: m.group(1) + "\n".join(required) + m.group(3),
           s)

# Replace next artifacts block (best-effort)
s = re.sub(r"(?s)(## Next artifacts \(ordered\)\n)(.*?)(\n## Open questions)",
           lambda m: m.group(1) + "\n".join(next_artifacts) + m.group(3),
           s)

# Update last updated date line
s = re.sub(r"(?m)^- YYYY-MM-DD\s*$", f"- {today}", s)

with open(stage, "w", encoding="utf-8") as f:
    f.write(s)

print(f"Initialized stage.md: {current} -> {nexts}")
PY
TARGET_DIR="$TARGET_DIR" python3 -c "pass" >/dev/null 2>&1 || true

# Make scripts executable if needed (no-op if already)
chmod +x scripts/*.sh 2>/dev/null || true

# Commit
git add "$TARGET_DIR" || true
git add scripts/*.sh 2>/dev/null || true

if git diff --cached --quiet; then
  echo "INFO: Nothing to commit (maybe files already existed)."
else
  git commit -m "chore(incubation): bootstrap ${NAME} (templates + stage)" \
             -m "- Scaffold /incubations/${NAME} from template" \
             -m "- Initialize stage.md for next-step planning"
fi

# Push
git push -u "$REMOTE" "$BRANCH"

echo
echo "✅ Branch pushed: $BRANCH"
echo
echo "Next:"
echo "  - Open a PR from '$BRANCH' into '$BASE_BRANCH'."
echo "  - If you have GitHub CLI installed:"
echo "      gh pr create --base \"$BASE_BRANCH\" --head \"$BRANCH\" --title \"Bootstrap incubation: ${NAME}\" --body \"Scaffold incubation and initialize stage tracking.\""
