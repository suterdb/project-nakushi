# ADR-003 — Data Model

- Date: 2026-07-26
- Status: Accepted
- Scope: Incubation: Linet

## Context

이전 project-nakushi ADR-003(삭제됨)은 RDS PostgreSQL + Prisma 기준이었다. `/dev/Linet`에서 진행 중인 Spring Boot 보일러플레이트는 Spring Data 기반이라 데이터 계층 기술이 바뀐다. 구체적인 엔티티 설계(이슈/작성 컨텐츠, 태그, 멘션 등)는 `spec.md`에서 상세화하며, 이 ADR은 데이터 계층의 기술적 선택만 다룬다.

## Decision

**MySQL 8.0 + Spring Data + Flyway**를 채택한다.

- DB 엔진: MySQL 8.0 (운영), H2 (dev 프로필 전용, 인메모리)
- 영속성: Spring Data (JPA) — 보일러플레이트 템플릿 기본 구성 활용
- 마이그레이션: Flyway, `src/main/resources/db/migration/V*.sql` 형식. **backward-compatible 변경만 허용** (컬럼 추가는 가능, 삭제는 별도 릴리스로 분리)
- 접속 정보: 환경변수(`DB_URL`, `DB_USERNAME`, `DB_PASSWORD`)로 주입, 평문 하드코딩 금지 — 운영 환경은 AWS Secrets Manager에서 IAM 역할로 조회

엔티티 상세(이슈 카드, 작성 컨텐츠, 태그, 멘션 관계 등)는 이번 ADR 범위가 아니며 `spec.md`에서 정의한다.

## Alternatives Considered
- Option A: PostgreSQL + Prisma (이전 project-nakushi ADR-003) — Next.js 스택 폐기와 함께 폐기. Prisma는 Node.js 생태계 도구라 Spring Boot와 맞지 않음
- Option B: MongoDB 등 NoSQL — 이슈/태그/멘션 간 관계형 구조(정규화)가 명확해 관계형 DB가 더 적합하다고 판단, 보류

## Consequences
- Pros: Spring Data + MySQL은 보일러플레이트에 이미 통합되어 있어 추가 세팅 비용이 낮음, Flyway로 스키마 변경 이력 추적 가능
- Cons: dev(H2)와 prod(MySQL) 간 방언 차이로 인한 이슈 가능성 — 통합 테스트에서 실제 MySQL 사용 권장
- Risks: 엔티티 설계가 아직 `spec.md`에서 확정되지 않아, 이 ADR만으로는 스키마 작업을 바로 시작할 수 없음

## Rollback Plan
Spring Data 추상화 덕분에 다른 관계형 DB(PostgreSQL 등)로 전환 시 드라이버 의존성과 Flyway 방언 설정만 교체하면 됨. 스키마 변경은 Flyway 이력으로 롤백 가능.
