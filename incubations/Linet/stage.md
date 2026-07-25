# Stage Status — Linet

CURRENT_STAGE: Stage 20 — Technical Baseline Fixed
NEXT_STAGE: Stage 30 — Execution Ready

## Required files (per current stage)
- [x] problem.md
- [x] mvp-scope.md
- [x] experiment-notes.md
- [x] stage.md
- [x] /ops/decisions/ADR-001-tech-stack.md
- [x] /ops/decisions/ADR-002-architecture.md
- [x] /ops/decisions/ADR-003-data-model.md
- [x] /ops/decisions/ADR-004-deployment.md

## Exit criteria check (Stage 20)
- [x] chosen stack is explicit — evidence: `ADR-001-tech-stack.md` "Java 21, Spring Boot 3.x ... DB: MySQL 8.0 ... `@RestController` 채택"
- [x] rollback notes exist for risky decisions — evidence: 4개 ADR 전부 "Rollback Plan" 섹션 존재 (예: ADR-004 "EC2 인스턴스 재기동/재생성으로 대응 ... 이전 ECR 이미지 태그로 롤백")
- [x] MVP has a minimal deploy plan — evidence: `ADR-004-deployment.md` "GitHub Actions(OIDC) → ECR → EC2(Tailscale) 경로"

## Next artifacts (ordered)
- [ ] `spec.md` (문제+MVP+ADR 종합 — 화면/API/데이터모델. `/dev/Linet`의 Phase 2 블로커인 "나크시 Linet 기획서 경로"를 해소하는 파일)
- [ ] `implementation-plan.md`
- [ ] `vertical-slice-01.md`
- [ ] GitHub Issues 재정리 (기존 #5–#15 재검토 반영)

## Open questions
- ~~기존 `/infra` CDK 코드 재검토~~ → **해결**: ADR-002/004에서 Nakushi 공유 인프라(CDK) 방식을 채택하지 않기로 결정. `/infra`의 기존 CDK 코드는 이번 Linet 재구현에는 사용하지 않음 (다른 인큐베이션에서 재사용 여지는 남겨둠, 삭제하지 않음)
- 기존 GitHub Issues [#5–#15](https://github.com/suterdb/project-nakushi/issues?q=is%3Aissue+label%3Alinet)는 새 스택(Spring Boot) 기준으로 내용이 안 맞으므로, `spec.md`/`implementation-plan.md` 작성 후 재정리 필요
- `spec.md` 완성 후 `/dev/Linet`의 `linet-aws-배포-작업계획.md` "빠진 입력값 1번"에 경로를 채워 Phase 2 블로커 해소

## Decision log (links)
- [ADR-001 Tech Stack](/ops/decisions/ADR-001-tech-stack.md) — Spring Boot(Hexagonal Architecture template) + MySQL + Flyway
- [ADR-002 Architecture](/ops/decisions/ADR-002-architecture.md) — Hexagonal Architecture, 독립 배포(Nakushi 공유 인프라 미사용), Tailscale, 알파 단계 인증 미구현
- [ADR-003 Data Model](/ops/decisions/ADR-003-data-model.md) — MySQL 8.0 + Spring Data + Flyway
- [ADR-004 Deployment](/ops/decisions/ADR-004-deployment.md) — GitHub Actions(OIDC) → ECR → EC2(Tailscale)

## Last updated
- 2026-07-26 (Stage 10 → Stage 20 완료, `/dev/Linet` 확정값 반영)
