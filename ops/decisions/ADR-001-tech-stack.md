# ADR-001 — Tech Stack

- Date: 2026-04-01
- Status: Accepted
- Scope: Incubation: Linet

## Context

Linet MVP는 웹 우선, 빠른 개발, AWS 기반 운영을 목표로 한다.
백엔드와 프론트엔드를 단일 레포에서 관리하며, LLM 태깅과 실시간 피드를 지원해야 한다.

## Decision

| 영역 | 선택 |
|---|---|
| 프레임워크 | Next.js (App Router) |
| 언어 | TypeScript |
| 실시간 피드 | 폴링 5초 (MVP) → Stage 40에서 AppSync 검토 |
| LLM 태깅 | Amazon Bedrock (Claude Haiku) |
| ORM | Prisma |

## Alternatives Considered

- Option A: Spring Boot + React 분리 — 팀 규모 대비 오버엔지니어링
- Option B: Node.js/Express + Next.js 분리 — 단일 레포 대비 관리 비용 증가
- Option C: Amplify Studio (no-code) — 커스터마이징 한계

## Consequences

- Pros:
  - Next.js API Routes로 프론트-백 단일 레포 유지
  - Bedrock은 AWS 네이티브로 별도 API 키 관리 불필요
  - Prisma로 DB 스키마와 마이그레이션 코드화
- Cons:
  - Next.js 서버 액션과 API Routes 혼용 시 구조 복잡도 증가 가능
  - 폴링 방식은 사용자 수 증가 시 DB 부하 유발
- Risks:
  - Bedrock Haiku 태깅 정확도가 기대 이하일 경우 GPT-4o-mini로 전환 필요

## Rollback Plan

- LLM: Bedrock → OpenAI API 전환은 서비스 레이어 교체로 가능 (인터페이스 분리 유지)
- 실시간: 폴링 → AppSync는 인프라 스택 추가로 점진적 전환 가능
