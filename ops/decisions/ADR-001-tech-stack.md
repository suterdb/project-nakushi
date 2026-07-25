# ADR-001 — Tech Stack

- Date: 2026-07-26
- Status: Accepted
- Scope: Incubation: Linet

## Context

빠른 MVP 검증을 위해 별도 리포지토리(`/dev/Linet`, GitHub `suterdb/Linet`)에서 Spring Boot 보일러플레이트 기반 구현을 이미 진행 중이다. 이 ADR은 그쪽에서 확정된 스택을 Nakushi 쪽 의사결정 기록으로 반영한다.

## Decision

**`kamilmazurek/hexagonal-architecture-template`을 베이스로 한 Java/Spring Boot 스택**을 채택한다.

- 언어/프레임워크: Java 21, Spring Boot 3.x (템플릿 고정 버전, 임의 업그레이드 금지)
- 빌드: Maven (`mvnw` 래퍼, 로컬 Maven 설치 불필요)
- DB: MySQL 8.0 (dev 프로필은 H2 유지), Flyway로 마이그레이션 관리
- API 스타일: OpenAPI-first 방식 폐기, 일반 `@RestController` 채택 — 이유: 자동화 루프에서 codegen 단계가 마찰을 유발하므로 도메인 반영 속도를 우선함
- 컨테이너 베이스 이미지: `eclipse-temurin:21-jre-alpine`

RSS 수집기(스케줄러, 파서 라이브러리 등 구현 세부)는 아직 미정 — Stage 20 이후 구현 단계에서 결정.

## Alternatives Considered
- Option A: Next.js + Prisma (이전 project-nakushi ADR-001, 폐기됨) — 사용자가 Spring Boot 보일러플레이트로 방향을 바꾸면서 폐기
- Option B: 다른 Spring Boot 보일러플레이트 후보들 (`/dev/Linet`의 `mvp-aws-boilerplate-검토-요약.md`에서 조사됨, 상세 비교는 해당 문서 참조) — Hexagonal Architecture 구조와 Spring Boot 3 + OpenAPI + Docker 기본 지원을 이유로 현재 템플릿 선택
- Option C: OpenAPI-first 코드 생성 유지 — Claude Code 자동화 루프와 마찰이 커서 폐기

## Consequences
- Pros: 보일러플레이트 덕분에 초기 세팅 시간 단축, Hexagonal Architecture로 도메인 로직과 인프라 분리, H2→MySQL 전환이 Spring Data 덕분에 용이
- Cons: Hexagonal Architecture는 소규모 MVP 기준으로는 구조적 오버헤드가 있음
- Risks: OpenAPI-first를 버려서 API 문서 자동화 이점을 포기함 — 문서화는 수동 관리 필요

## Rollback Plan
구조가 과하다고 판단되면 동일 저자의 Layered Architecture Template으로 전환 가능. DB는 Spring Data 추상화 덕분에 MySQL 외 다른 RDB로 전환 시 마이그레이션 스크립트(Flyway) 재작성 정도로 대응 가능.
