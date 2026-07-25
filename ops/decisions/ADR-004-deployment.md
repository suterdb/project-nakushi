# ADR-004 — Deployment

- Date: 2026-04-01
- Status: Accepted
- Scope: Incubation: Linet (+ Nakushi 공통 전략)

## Context

MVP를 빠르게 배포하고, 이후 서비스 추가 시 동일한 배포 파이프라인을 재사용해야 한다.
Claude Code를 통한 배포 자동화가 가능해야 하며, 수동 콘솔 작업은 최소화한다.

## Decision

**AWS CDK + AWS Amplify** 기반 자동화 배포

### 배포 파이프라인

```
[Claude Code]
  → CDK 코드 작성/수정
  → cdk bootstrap (최초 1회)
  → cdk deploy --all
  → Prisma migrate deploy (DB 마이그레이션)
  → Amplify 앱 빌드/배포

[사용자 수동 (최초 1회)]
  → aws configure (자격증명)
  → Bedrock 모델 활성화 (콘솔)
```

### 환경 전략

| 환경 | 용도 | 배포 방식 |
|---|---|---|
| dev | 로컬 개발 | Next.js dev server + 로컬 DB |
| staging | Alpha/Beta 테스트 | CDK deploy (별도 스택) |
| production | 실서비스 | CDK deploy (main 브랜치 연동) |

### 신규 서비스 추가 시

```typescript
// nakushi.ts에 스택 1개 추가로 완료
new MirrorStack(app, 'Mirror', { sharedStack });
```

## Alternatives Considered

- Option A: Vercel + 별도 DB — AWS 외부, 통합 비용 관리 어려움
- Option B: EC2 직접 관리 — 운영 부담 과다
- Option C: ECS Fargate — MVP 수준에서 오버스펙, 비용 증가

## Consequences

- Pros:
  - `cdk deploy` 한 번으로 전체 인프라 프로비저닝
  - CloudFormation 상태 관리로 드리프트 감지 가능
  - Claude Code가 스택 코드 생성 → 배포까지 자동화
  - 신규 서비스 추가 시 스택 1개 추가로 완료
- Cons:
  - CDK 초기 학습 비용 (부트스트랩, 스택 구조 이해)
  - Amplify 빌드 시간 (~3-5분) 존재
- Risks:
  - CDK 버전 업그레이드 시 Breaking Change 가능 → CDK 버전 고정 관리 필요

## Rollback Plan

- CloudFormation 스택 롤백: `cdk deploy` 실패 시 자동 롤백
- 앱 롤백: Amplify 이전 배포 버전으로 즉시 전환 가능 (콘솔 또는 CLI)
- DB 롤백: Prisma migrate 롤백 스크립트 사전 준비
