# Stage Status — Linet

CURRENT_STAGE: Stage 30 — Execution Ready
NEXT_STAGE: Stage 40 — Active Build

## Required files (per current stage)
- [x] problem.md
- [x] mvp-scope.md
- [x] experiment-notes.md
- [x] stage.md
- [x] /ops/decisions/ADR-001-tech-stack.md
- [x] /ops/decisions/ADR-002-architecture.md
- [x] /ops/decisions/ADR-003-data-model.md
- [x] /ops/decisions/ADR-004-deployment.md
- [x] spec.md
- [x] implementation-plan.md
- [x] vertical-slice-01.md

## Exit criteria check (Stage 20 — passed)
- [x] chosen stack is explicit — evidence: `ADR-001-tech-stack.md` "Java 21, Spring Boot 3.x ... DB: MySQL 8.0 ... `@RestController` 채택"
- [x] rollback notes exist for risky decisions — evidence: 4개 ADR 전부 "Rollback Plan" 섹션 존재
- [x] MVP has a minimal deploy plan — evidence: `ADR-004-deployment.md` "GitHub Actions(OIDC) → ECR → EC2(Tailscale) 경로"

## Exit criteria check (Stage 30 — in progress)
- [x] `spec.md` exists and covers screen list, API list, data model — evidence: `spec.md`의 "Screens", "API list", "Data model (summary)" 섹션
- [x] `implementation-plan.md` traces back to `spec.md` — evidence: `implementation-plan.md` 첫 줄 "이 계획은 `spec.md`(화면/API/데이터 모델)를 구현 순서로 쪼갠 것이다. 스펙 자체는 재기술하지 않고 `spec.md`를 참조한다."
- [x] vertical slice can be built in 1–3 days — evidence: `vertical-slice-01.md`의 VS-01 범위가 태그/LLM/공감/멘션/이슈 피드를 제외한 "작성→저장→노출→삭제/숨김"만이라 CRUD 수준, 1~3일 내 가능하다고 판단
- [ ] issue list exists and maps to plan — 미충족. 기존 GitHub Issues #5–#15는 구 스택(Next.js) 기준이라 `implementation-plan.md`의 VS-01~04와 맞지 않음, 재정리 필요

## Next artifacts (ordered)
- [ ] GitHub Issues 재정리 (VS-01~04 기준으로 8~12개, 기존 #5–#15 반영/폐기 판단)
- [ ] `/ops/reports/YYYY-W##.md` (주간 리포트 시작)
- [ ] VS-01 구현 및 머지 (Stage 40 진입 조건)

## Open questions
- ~~기존 `/infra` CDK 코드 재검토~~ → **해결**: ADR-002/004에서 Nakushi 공유 인프라(CDK) 방식을 채택하지 않기로 결정. `/infra`의 기존 CDK 코드는 이번 Linet 재구현에는 사용하지 않음 (다른 인큐베이션에서 재사용 여지는 남겨둠, 삭제하지 않음)
- ~~`spec.md` 완성 후 `/dev/Linet`의 "빠진 입력값 1번" 해소~~ → **해결**: 경로는 `project-nakushi/incubations/Linet/spec.md`, 반영은 해당 리포 세션에서 직접 처리
- 기존 GitHub Issues [#5–#15](https://github.com/suterdb/project-nakushi/issues?q=is%3Aissue+label%3Alinet) 재정리 필요 — 구 스택 기준이라 VS-01~04와 불일치
- RSS 폴링 주기(10분 잠정), LLM 벤더는 `spec.md`에 열린 질문으로 남아있음 — 구현 중 확정 필요
- `spec.md`에 `Content.deleted_at` 컬럼 보강됨 (VS-01 상세화 중 발견, soft delete 필요성 때문)

## Decision log (links)
- [ADR-001 Tech Stack](/ops/decisions/ADR-001-tech-stack.md) — Spring Boot(Hexagonal Architecture template) + MySQL + Flyway
- [ADR-002 Architecture](/ops/decisions/ADR-002-architecture.md) — Hexagonal Architecture, 독립 배포(Nakushi 공유 인프라 미사용), Tailscale, 알파 단계 인증 미구현
- [ADR-003 Data Model](/ops/decisions/ADR-003-data-model.md) — MySQL 8.0 + Spring Data + Flyway
- [ADR-004 Deployment](/ops/decisions/ADR-004-deployment.md) — GitHub Actions(OIDC) → ECR → EC2(Tailscale)

## Last updated
- 2026-07-26 (Stage 20 → Stage 30 진입, GitHub Issues 재정리만 남음)
