# Vertical Slice 01 — Linet

Goal: 작성 피드 최소 흐름(UI → API → DB → UI)을 end-to-end로 완성한다. `implementation-plan.md`의 VS-01 범위이며, 태그/LLM/공감/멘션/이슈 피드는 포함하지 않는다(각각 VS-02~04).

## Flow
1) UI action: 사용자가 하단 고정 입력창 클릭 → 확장 → 140자 이내 한 줄 입력 → 전송
2) API endpoint: `POST /api/writes` `{deviceId, body}` (VS-01 범위에서는 태그 없이 본문만)
3) DB write/read: `User`(device_id upsert) → `Content`(type=WRITE, body, author_id, created_at) insert
4) UI output: 작성 피드(`GET /api/feed/writes`) 최상단에 방금 작성한 카드 노출

## Sequence (happy path)
1. 최초 방문 시 프론트에서 `device_id`가 없으면 UUID 생성 후 localStorage에 저장
2. 입력창 확장 → 140자 이내 입력 → 전송
3. 프론트: `POST /api/writes {deviceId, body}`
4. 서버: `device_id`로 `User` upsert → `Content(type=WRITE, body, author_id, created_at)` insert
5. 서버: 생성된 카드(id, body, like_count=0, created_at) 응답
6. 프론트: 작성 피드 최상단에 카드 추가 (낙관적 UI)
7. 다른 클라이언트가 `GET /api/feed/writes` 호출 시 최신순으로 해당 카드 포함되어 노출
8. 작성자 본인이 ✖️ 클릭 → `DELETE /api/contents/{id} {deviceId}` → `author_id` 일치 확인 후 `Content.deleted_at` 설정(soft delete)
9. 작성자가 아닌 소비자가 ✖️ 클릭 → `POST /api/contents/{id}/hide {deviceId}` → `HiddenContent(user_id, content_id)` insert → 이후 해당 사용자의 `GET /api/feed/writes` 응답에서만 제외됨 (원본은 유지)

**스펙 보강 사항**: `spec.md`의 `Content` 테이블에 `deleted_at`(nullable) 컬럼이 빠져 있었음 — soft delete를 위해 VS-01에서 추가. hard delete로 하면 이후 VS-03(멘션)에서 삭제된 원글을 멘션이 참조할 때 깨지므로 soft delete로 결정.

## Failure modes
- 140자 초과 입력 → 400 (프론트 사전 검증 + 서버 재검증)
- `deviceId` 누락/형식 불일치 → 400
- 존재하지 않는 `content_id`로 삭제/숨김 시도 → 404
- 본인 컨텐츠가 아닌데 `DELETE` 시도 → 403 (소비자는 `/hide`만 호출 가능하도록 프론트에서 분기, 서버도 `author_id` 재검증)
- 이미 숨긴 컨텐츠를 다시 `/hide` 호출 → idempotent 처리 (unique(user_id, content_id) 충돌 시 204로 응답, 에러 아님)

## Logging / observability
- `/actuator/health`만 외부 노출 (ADR-004)
- 작성/삭제/숨김 이벤트는 구조화 로그로 stdout → CloudWatch Logs (action, content_id, device_id는 원문 대신 해시로 기록 — 알파 단계라도 식별자 원문 로깅은 지양)

## Definition of Done
- [ ] 로컬에서 `docker compose up`으로 실행 가능 (H2 dev 프로필)
- [ ] `/dev/Linet` 테스트 환경(EC2 + Tailscale)에 배포됨
- [ ] 스모크 테스트 문서화: `curl`로 작성 → 피드 조회 → 삭제 → 숨김 4단계 재현 가능한 스크립트/커맨드 기록
