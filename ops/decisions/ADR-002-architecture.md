# ADR-002 — Architecture

- Date: 2026-04-01
- Status: Accepted
- Scope: Incubation: Linet (+ Nakushi 공통 전략)

## Context

Linet는 Nakushi의 첫 번째 인큐베이션 서비스다.
이후 Mirror, Recipe Adapter 등 복수의 서비스가 동일 인프라를 공유할 가능성이 높다.
서비스별로 인프라를 독립 생성하면 비용이 배증되므로, 공유 가능한 구조가 필요하다.

## Decision

**Nakushi 공유 인프라 + 서비스별 앱 레이어** 구조를 채택한다.

```
/infra (AWS CDK — TypeScript)
  /lib
    /constructs
      NakushiApp.ts        # Amplify 앱 공통 설정
      NakushiDatabase.ts   # RDS + VPC
      NakushiLLM.ts        # Bedrock IAM 권한
    /stacks
      shared-stack.ts      # VPC, RDS 클러스터 (모든 서비스 공유)
      linet-stack.ts       # Linet 전용 리소스
      mirror-stack.ts      # Mirror (추후)
  bin/
    nakushi.ts
```

Linet 앱 자체는 **Next.js 모놀리스**로 시작한다.
- API Routes: 콘텐츠 CRUD, 태그, 멘션
- Server Actions: 폼 처리
- 마이크로서비스 분리는 Stage 40 이후 트래픽 확인 후 결정

## Alternatives Considered

- Option A: 서비스별 독립 인프라 — RDS/VPC 중복으로 비용 배증
- Option B: Kubernetes (EKS) — MVP 수준에서 오버스펙
- Option C: 서버리스 (Lambda only) — 실시간 피드 구현 시 Cold Start 문제

## Consequences

- Pros:
  - 신규 서비스 추가 시 CDK 스택 1개만 추가
  - RDS 1개 공유로 운영 비용 최소화
  - Claude Code가 스택 코드 자동 생성 가능 → 배포 자동화
- Cons:
  - shared-stack 변경 시 모든 서비스에 영향
  - 초기 CDK 셋업 비용 존재
- Risks:
  - RDS 공유 시 특정 서비스 트래픽 폭증이 타 서비스에 영향 가능 → RDS 스케일업으로 대응

## Rollback Plan

- 서비스별 독립 스택으로 분리는 CDK 리팩터링으로 가능
- 모놀리스 → 마이크로서비스 분리는 Next.js API Routes를 독립 서비스로 추출하는 방식으로 점진 전환
