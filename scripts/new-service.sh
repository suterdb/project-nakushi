#!/usr/bin/env bash
# Nakushi: 새 서비스 인큐베이션 생성 (wrapper)
# Usage: ./scripts/new-service.sh <service-name>
#
# 이 스크립트는 nakushi-init-incubation.sh 의 alias 입니다.
# 설계 문서(nakushi-architecture-execution-system-v1.md) 규칙:
#   새 서비스는 반드시 이 스크립트로 생성한다 (수동 생성 금지).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <service-name>"
  echo ""
  echo "Example:"
  echo "  ./scripts/new-service.sh myapp"
  exit 1
fi

exec "${SCRIPT_DIR}/nakushi-init-incubation.sh" "$@"
