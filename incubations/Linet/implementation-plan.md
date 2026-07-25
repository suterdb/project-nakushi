# Implementation Plan — Linet

## 목표

Stage 20에서 확정된 기술 스택으로 MVP를 구현한다.
첫 번째 수직 슬라이스(VS-01)를 1–3일 내에 완성하는 것이 출발점이다.

## 스택 요약 (ADR 기준)

- 앱: Next.js (App Router, TypeScript)
- DB: RDS PostgreSQL + Prisma
- LLM 태깅: Amazon Bedrock (Claude Haiku)
- 배포: AWS CDK + Amplify
- 실시간 피드: 5초 폴링

---

## 구현 순서

### Phase 1 — 인프라 (VS-01 이전)

| 순서 | 작업 | 산출물 |
|---|---|---|
| 1 | CDK 프로젝트 초기화 (`/infra`) | `shared-stack.ts`, `linet-stack.ts` |
| 2 | RDS PostgreSQL 프로비저닝 | DB 엔드포인트 확보 |
| 3 | Amplify 앱 연결 | 배포 파이프라인 동작 확인 |
| 4 | Prisma 초기 스키마 + 마이그레이션 | `schema.prisma`, 첫 마이그레이션 |

### Phase 2 — 수직 슬라이스 01: 콘텐츠 작성 + 피드 노출

→ `vertical-slice-01.md` 참조

| 순서 | 작업 |
|---|---|
| 1 | 사용자 생성 (핸들 입력, 최소 인증) |
| 2 | 콘텐츠 작성 API (`POST /api/posts`) |
| 3 | 피드 조회 API (`GET /api/feed`) + 5초 폴링 |
| 4 | 기본 UI (입력창 + 피드 목록) |

### Phase 3 — 수직 슬라이스 02: 태그

| 순서 | 작업 |
|---|---|
| 1 | Bedrock Haiku 태그 추천 API |
| 2 | 태그 저장 + post_tags 연결 |
| 3 | 태그 클릭 → 필터링 피드 |
| 4 | 태그 검색 + 자동완성 |

### Phase 4 — 수직 슬라이스 03: 멘션

| 순서 | 작업 |
|---|---|
| 1 | `>>contentID` 파싱 로직 |
| 2 | mentions 테이블 저장 |
| 3 | 멘션 수 집계 갱신 |
| 4 | 멘션 입력 UI (💬 버튼) |

---

## 의존성 맵

```
CDK 인프라
  └→ RDS 엔드포인트
       └→ Prisma 마이그레이션
            └→ VS-01 (콘텐츠 + 피드)
                 └→ VS-02 (태그 + Bedrock)
                      └→ VS-03 (멘션)
```

## 완료 기준 (Stage 30 Exit)

- [ ] VS-01 머지 완료
- [ ] CDK deploy로 staging 환경 동작
- [ ] GitHub Issues 8–12개 생성 및 VS-01과 연결
