# ADR-003 — Data Model

- Date: 2026-04-01
- Status: Accepted
- Scope: Incubation: Linet

## Context

Linet의 핵심 데이터 구조는 콘텐츠(한 줄), 태그, 멘션(콘텐츠 간 참조)이다.
태그와 멘션은 명확한 관계형 구조를 가지며, 향후 태그 기반 탐색과 멘션 집계가 필요하다.

## Decision

**Amazon RDS PostgreSQL** (shared-stack 내 단일 인스턴스, 서비스별 스키마 분리)

### 핵심 스키마 (Linet)

```sql
-- 콘텐츠
posts (id, user_id, body VARCHAR(140), mention_count INT, created_at)

-- 태그
tags (id, name UNIQUE)
post_tags (post_id, tag_id)          -- N:M

-- 멘션 (콘텐츠 간 참조)
mentions (id, from_post_id, to_post_id, created_at)

-- 사용자 (MVP 최소)
users (id, handle UNIQUE, created_at)
```

### 운영 전략

- 인스턴스: t3.micro (프리티어 12개월) → 이후 t3.small
- 서비스별 스키마 분리: `linet.*`, `mirror.*` (멀티테넌트 대비)
- Prisma로 마이그레이션 코드화 (자동화 가능)

## Alternatives Considered

- Option A: DynamoDB — 태그/멘션 관계 쿼리가 복잡, JOIN 불가
- Option B: Aurora Serverless v2 — 비용 변동성 있음, MVP에서 예측 어려움
- Option C: Supabase — AWS 외부 서비스, 통합 비용 관리 어려움

## Consequences

- Pros:
  - 태그/멘션 집계 쿼리가 SQL로 단순하게 처리 가능
  - Prisma 마이그레이션으로 스키마 변경 추적 가능
  - 스키마 분리로 서비스 간 데이터 격리
- Cons:
  - RDS 공유 시 스키마 관리 규칙 필요
  - NoSQL 대비 수평 확장 복잡
- Risks:
  - 태그 검색 성능 — `post_tags.tag_id` 인덱스로 대응
  - 실시간 피드 폴링 부하 — `posts.created_at` 인덱스 + 폴링 주기 조정

## Rollback Plan

- Aurora Serverless v2 전환은 RDS 스냅샷 → Aurora 복원으로 가능 (다운타임 최소)
- 스키마 변경은 Prisma 마이그레이션으로 추적되므로 롤백 스크립트 자동 생성 가능
