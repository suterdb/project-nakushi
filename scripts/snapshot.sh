#!/usr/bin/env bash
# Nakushi: 프로젝트 상태 스냅샷 생성
# Usage: ./scripts/snapshot.sh
# Output: ops/snapshots/YYYY-MM-DD.json

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TODAY="$(date +%Y-%m-%d)"
SNAPSHOT_FILE="${REPO_ROOT}/ops/snapshots/${TODAY}.json"

cd "$REPO_ROOT"

# incubation 목록 수집
INCUBATIONS=()
for dir in incubations/*/; do
  name="$(basename "$dir")"
  [[ "$name" == "_template" ]] && continue
  INCUBATIONS+=("$name")
done

# 각 incubation의 stage 정보 수집
build_incubation_json() {
  local name="$1"
  local stage_file="incubations/${name}/stage.md"

  local current_stage="unknown"
  local next_stage="unknown"
  local checked=0
  local total=0

  if [[ -f "$stage_file" ]]; then
    current_stage="$(grep '^CURRENT_STAGE:' "$stage_file" | sed 's/CURRENT_STAGE: //' || echo 'unknown')"
    next_stage="$(grep '^NEXT_STAGE:' "$stage_file" | sed 's/NEXT_STAGE: //' || echo 'unknown')"
    checked="$(grep -c '^\- \[x\]' "$stage_file" || true)"
    total="$(grep -c '^\- \[.\]' "$stage_file" || true)"
  fi

  local files
  files="$(ls "incubations/${name}/" 2>/dev/null | tr '\n' ',' | sed 's/,$//' || echo '')"

  cat <<JSON
    {
      "name": "${name}",
      "current_stage": "${current_stage}",
      "next_stage": "${next_stage}",
      "checklist_progress": "${checked}/${total}",
      "files": "${files}"
    }
JSON
}

# git 정보
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
GIT_COMMIT_MSG="$(git log -1 --pretty=%s 2>/dev/null || echo 'unknown')"

# JSON 생성
{
  echo "{"
  echo "  \"generated_at\": \"${TODAY}\","
  echo "  \"git\": {"
  echo "    \"branch\": \"${GIT_BRANCH}\","
  echo "    \"commit\": \"${GIT_COMMIT}\","
  echo "    \"last_message\": \"${GIT_COMMIT_MSG}\""
  echo "  },"
  echo "  \"incubations\": ["

  first=true
  for name in "${INCUBATIONS[@]}"; do
    if [[ "$first" == true ]]; then
      first=false
    else
      echo ","
    fi
    build_incubation_json "$name"
  done

  echo "  ]"
  echo "}"
} > "$SNAPSHOT_FILE"

echo "Snapshot saved: ${SNAPSHOT_FILE}"
cat "$SNAPSHOT_FILE"
