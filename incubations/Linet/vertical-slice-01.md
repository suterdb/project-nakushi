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
9. 작성자가 아닌 소비자가 ✖️ 클릭 → **서버 호출 없음.** 프론트가 `content id`를 `localStorage`(`linet_hidden_content_ids`)에 추가하고, 이후 이 기기에서 로드하는 피드 응답을 클라이언트에서 필터링 (원본은 서버에 그대로 유지, 다른 기기/사용자에게는 영향 없음)

**스펙 보강 사항**: `spec.md`의 `Content` 테이블에 `deleted_at`(nullable) 컬럼이 빠져 있었음 — soft delete를 위해 VS-01에서 추가. hard delete로 하면 이후 VS-03(멘션)에서 삭제된 원글을 멘션이 참조할 때 깨지므로 soft delete로 결정.

**스펙 변경 (구현 중 재검토)**: 소비자의 "숨기기"는 최초에 `POST /api/contents/{id}/hide` + `HiddenContent(user_id, content_id)` 테이블로 구현했으나, PR 리뷰 중 오버스펙으로 판단해 제거하고 클라이언트(localStorage) 전용으로 단순화함 — `device_id` 자체가 브라우저 로컬 식별자라 서버 계정과 연동되지 않으므로, 숨김 여부를 서버에 영속화해도 브라우저가 바뀌면 어차피 함께 무의미해져 실익이 없음. 상세: `suterdb/Linet` PR #18, `.docs/spec/backend.md`/`frontend.md`("숨김 정책").

## Failure modes
- 140자 초과 입력 → 400 (프론트 사전 검증 + 서버 재검증)
- `deviceId` 누락/형식 불일치 → 400
- 존재하지 않는 `content_id`로 삭제 시도 → 404 (숨김은 서버 호출이 없어 해당 없음)
- 본인 컨텐츠가 아닌데 `DELETE` 시도 → 403 (소비자는 로컬 숨김만 가능하도록 프론트에서 분기, 서버도 `author_id` 재검증)
- 이미 숨긴 컨텐츠를 다시 숨기기 시도 → 프론트에서 idempotent 처리 (`hideContentLocally`가 이미 있는 id는 중복 추가 안 함)

## Logging / observability
- `/actuator/health`만 외부 노출 (ADR-004)
- 작성/삭제 이벤트는 구조화 로그로 stdout → CloudWatch Logs (action, content_id, device_id는 원문 대신 해시로 기록 — 알파 단계라도 식별자 원문 로깅은 지양). 숨김은 서버를 안 거치므로 서버 로그에 남지 않음 (클라이언트 전용 동작)

## Definition of Done
- [ ] 로컬에서 `docker compose up`으로 실행 가능 (H2 dev 프로필)
- [ ] `/dev/Linet` 테스트 환경(EC2 + Tailscale)에 배포됨
- [ ] 스모크 테스트 문서화: `curl`로 작성 → 피드 조회 → 삭제 3단계 재현 가능한 스크립트/커맨드 기록 (숨김은 프론트 전용 기능이라 curl 대상 아님, 브라우저로 확인)
