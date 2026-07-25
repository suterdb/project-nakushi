# ADR-002 — Architecture

- Date: 2026-07-26
- Status: Accepted
- Scope: Incubation: Linet

## Context

Linet은 독립 리포지토리(`suterdb/Linet`)에서 별도로 구현되며, 폐쇄 알파(소수 테스터) 배포를 최종 목표로 한다. 이전 project-nakushi ADR-002(삭제됨)는 "Nakushi 공유 인프라(CDK) + 서비스별 앱 레이어" 전략이었으나, 이번 방향 전환(Spring Boot 보일러플레이트, 별도 리포)에서는 이 공유 전략을 따르지 않는다.

## Decision

**Hexagonal Architecture(Ports & Adapters) + 독립 배포 구조**를 채택한다.

- 코드 구조: `domain / application / infrastructure / presentation` 패키지 분리
- 배포 경로: **Tailscale + EC2 단일 인스턴스** (App Runner 아님) — 알파 소수 테스터 전제
- 인프라 공유: **하지 않음.** project-nakushi의 "Nakushi 공유 인프라 + 서비스별 앱 레이어" 원칙(구 ADR-002)은 이번 Linet 재구현에는 적용하지 않는다. `/dev/Linet`은 자체 EC2/RDS/VPC(리전 기본 VPC)를 독립적으로 프로비저닝한다.
- 인증: 알파 단계에서는 앱 레벨 인증을 구현하지 않는다 — Tailscale이 네트워크 레벨에서 접근을 이미 통제하므로 JWT/초대 토큰 이중 구현이 불필요하다고 판단. 공개 베타 전환 시 JWT 도입 예정.
- 브랜치 전략: `main` 보호, 기능 브랜치 → PR → 사람 머지 (Claude Code는 push/PR까지만 수행)

## Alternatives Considered
- Option A: 기존 Nakushi 공유 인프라(CDK 공유 스택) 재사용 — 스택 자체가 Next.js/AWS Bedrock 기준으로 짜여 있어 Spring Boot 전환과 맞지 않아 폐기
- Option B: App Runner 기반 퍼블릭 배포 — 알파 단계에서는 접근 통제가 더 단순한 Tailscale 경로가 낫다고 판단해 보류 (`/dev/Linet` 문서 §0-1에서 이미 확정)
- Option C: 알파 단계부터 JWT 인증 구현 — Tailscale이 네트워크 레벨 통제를 제공하므로 이중 구현 불필요하다고 판단해 보류

## Consequences
- Pros: 인프라를 독립적으로 관리해 다른 인큐베이션(Mirror 등)과의 결합도가 없음, Tailscale 덕분에 알파 단계 보안 설정이 단순함
- Cons: Nakushi의 "인프라 공유로 비용 절감" 원래 취지와는 어긋남 — Linet만의 EC2/RDS 비용이 별도로 발생
- Risks: 공개 베타로 확장 시 App Runner/공유 인프라 경로로 재설계가 필요할 수 있음 (Tailscale은 소수 테스터 규모에 최적화된 경로)

## Rollback Plan
공개 베타 전환 시점에 App Runner 또는 별도 컨테이너 오케스트레이션 경로로 재설계. JWT 인증은 필요 시점에 별도 Phase로 추가 가능하도록 Hexagonal 구조상 infrastructure 어댑터 계층에만 격리해서 구현할 것.
