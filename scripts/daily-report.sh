#!/usr/bin/env bash
# Nakushi: 일일 보고서 자동 생성
# Usage: ./scripts/daily-report.sh [tomorrow-task]
# Output: ops/reports/YYYY-MM-DD.md

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TODAY="$(date +%Y-%m-%d)"
REPORT_FILE="${REPO_ROOT}/ops/reports/${TODAY}.md"

cd "$REPO_ROOT"

# 이미 존재하면 경고
if [[ -f "$REPORT_FILE" ]]; then
  echo "INFO: Report already exists for today: ${REPORT_FILE}"
  echo "      Edit it directly or delete it to regenerate."
  exit 0
fi

# 오늘의 git 커밋 로그
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
GIT_LOG="$(git log --since="$(date +%Y-%m-%d) 00:00:00" --until="$(date +%Y-%m-%d) 23:59:59" \
           --pretty=format:'- %s (%h)' 2>/dev/null || echo '- (no commits today)')"

if [[ -z "$GIT_LOG" ]]; then
  GIT_LOG="- (no commits today)"
fi

# incubation 상태 요약
INCUBATION_SUMMARY=""
for dir in incubations/*/; do
  name="$(basename "$dir")"
  [[ "$name" == "_template" ]] && continue
  stage_file="incubations/${name}/stage.md"
  if [[ -f "$stage_file" ]]; then
    current="$(grep '^CURRENT_STAGE:' "$stage_file" | sed 's/CURRENT_STAGE: //' || echo 'unknown')"
    INCUBATION_SUMMARY+="- **${name}**: ${current}"$'\n'
  else
    INCUBATION_SUMMARY+="- **${name}**: stage.md 없음"$'\n'
  fi
done

if [[ -z "$INCUBATION_SUMMARY" ]]; then
  INCUBATION_SUMMARY="- (인큐베이션 없음)"
fi

# 내일 할 일 (인자로 전달하거나 비워 둠)
TOMORROW_TASK="${1:-(직접 작성)}"

# 보고서 생성
cat > "$REPORT_FILE" <<REPORT
# Daily Report — ${TODAY}

Branch: ${GIT_BRANCH}

---

## 오늘 한 일

### Git 커밋
${GIT_LOG}

### 작업 요약
- (직접 작성)

---

## 인큐베이션 현황

${INCUBATION_SUMMARY}

---

## 내일 할 일 (최우선 1개)

${TOMORROW_TASK}

---

## 메모 / 블로커

- (직접 작성)
REPORT

echo "Daily report created: ${REPORT_FILE}"

# 스냅샷도 함께 실행
if [[ -x "${REPO_ROOT}/scripts/snapshot.sh" ]]; then
  echo ""
  echo "Running snapshot..."
  "${REPO_ROOT}/scripts/snapshot.sh"
fi
