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

## Next artifacts (ordered)
- [ ] /incubations/Linet/implementation-plan.md
- [ ] /incubations/Linet/vertical-slice-01.md
- [ ] GitHub Issues breakdown (8–12개)

## Decision log (links)
- [ADR-001 Tech Stack](/ops/decisions/ADR-001-tech-stack.md) — Next.js + Bedrock + 폴링
- [ADR-002 Architecture](/ops/decisions/ADR-002-architecture.md) — CDK 공유 스택 + Next.js 모놀리스
- [ADR-003 Data Model](/ops/decisions/ADR-003-data-model.md) — RDS PostgreSQL + Prisma
- [ADR-004 Deployment](/ops/decisions/ADR-004-deployment.md) — CDK + Amplify 자동화

## Open questions (resolved)
- [x] 백엔드 스택 → Next.js (App Router)
- [x] DB → RDS PostgreSQL (shared-stack)
- [x] 실시간 피드 → 폴링 5초 (MVP), AppSync는 Stage 40 검토
- [x] LLM 태깅 → Amazon Bedrock (Claude Haiku)
- [x] 배포 → AWS CDK + Amplify 자동화

## Last updated
- 2026-04-01
