# Implementation Plan — Linet (MVP)

이 계획은 `spec.md`(화면/API/데이터 모델)를 구현 순서로 쪼갠 것이다. 스펙 자체는 재기술하지 않고 `spec.md`를 참조한다.

## 1) MVP Feature Breakdown (수직 슬라이스 순서)
- **VS-01: 작성 피드 최소 흐름** — 한 줄 작성 → 저장 → 작성 피드 노출 → 삭제(작성자)/숨김(소비자)
- **VS-02: 태그 + 공감** — LLM 태그 추천, 태그 필터 피드, 좋아요 토글
- **VS-03: 멘션** — 멘션 작성, 원글 멘션 수 갱신, 멘션 목록 조회
- **VS-04: 이슈 피드** — RSS 수집 배치(마이데일리/스포츠경향) → LLM 요약·태깅 → 이슈 탭 노출

이 순서로 잡은 이유: VS-01은 DB/엔티티/기본 CRUD를 가장 단순한 형태로 먼저 검증하고, VS-04(이슈 피드·외부 연동·배치·LLM)는 가장 복잡하고 `/dev/Linet` Phase 1(보일러플레이트/MySQL 전환)이 끝나야 붙일 수 있는 부분이라 마지막에 배치했다.

## 2) API Spec Draft (spec.md 참조, VS별 배치)
- VS-01: `POST /api/writes`, `GET /api/feed/writes`, `DELETE /api/contents/{id}`, `POST /api/contents/{id}/hide`
- VS-02: `POST /api/contents/{id}/like`, `GET /api/tags/{tag}/feed`, `GET /api/tags/autocomplete`
- VS-03: `POST /api/contents/{id}/mentions`, `GET /api/contents/{id}/mentions`
- VS-04: `GET /api/feed/issues`, (내부) RSS 수집 배치

전체 요청/응답 형태는 `spec.md`의 API list를 그대로 따른다.

## 3) Data Schema Draft (Flyway 마이그레이션 순서, ADR-003 기준)
- `V1__init.sql`: `User`(device_id), `Content`(type, body, author_id, source_name/url, like_count, created_at), `HiddenContent`
- `V2__add_tags_and_likes.sql`: `Tag`, `ContentTag`, `Like`
- `V3__add_mentions.sql`: `Mention`
- VS-04는 신규 테이블 없이 `Content.type=ISSUE`를 재사용 — RSS 수집 배치 컴포넌트만 추가

각 마이그레이션은 ADR-003 원칙대로 backward-compatible(추가만)하게 작성한다.

## 4) Milestones (4주, `/dev/Linet` Phase 진행과 병행)
### Week 1 — VS-01
- `/dev/Linet` Phase 1(보일러플레이트 H2→MySQL, OpenAPI 제거) 마무리와 병행
- VS-01 구현 및 머지

### Week 2 — VS-02
- 태그 자동완성/필터, 좋아요 토글
- LLM 포트(`LlmTaggingPort`) 인터페이스 정의 (벤더는 아직 미확정 — spec.md open question)

### Week 3 — VS-03 + VS-04 착수
- 멘션 구현
- LLM 벤더 확정 후 RSS 수집 배치 + 요약/태깅 어댑터 구현

### Week 4 — 폐쇄 알파 배포 준비
- `/dev/Linet` Phase 3~5 (CI/CD, AWS 인프라, Tailscale 접근 구성)
- 알파 테스터 모집 및 초대

## 5) Acceptance Criteria (Yes/No)
- [ ] VS-01: 한 줄 작성 → 피드 노출 → 삭제/숨김이 실제 DB에 반영되고 API로 재현 가능
- [ ] VS-02: 좋아요 토글이 중복 없이 동작하고, 태그 클릭 시 필터링된 피드가 노출됨
- [ ] VS-03: 멘션 작성 시 원글 멘션 수가 갱신되고, 멘션 목록이 조회됨
- [ ] VS-04: RSS 폴링이 스케줄대로 동작하고, 이슈 카드가 이슈 탭에 노출됨
- [ ] 폐쇄 알파 테스터가 Tailscale 경로로 접속해 VS-01~04를 오류 없이 사용 가능
