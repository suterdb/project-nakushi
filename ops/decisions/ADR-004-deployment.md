# ADR-004 — Deployment

- Date: 2026-07-26
- Status: Accepted
- Scope: Incubation: Linet

## Context

이전 project-nakushi ADR-004(삭제됨)는 CDK + Amplify 자동화 기준이었다. `/dev/Linet`은 별도 리포에서 Tailscale 기반 알파 배포 경로를 이미 확정해 진행 중이다 (`linet-aws-배포-작업계획.md` 기준).

## Decision

**GitHub Actions(OIDC) → ECR → EC2(Tailscale) 경로**를 채택한다.

- 리전: `ap-northeast-2` (서울)
- 컴퓨트: EC2 1대, `t4g.small` (ARM64), Amazon Linux 2023, VPC는 리전 기본 VPC 사용 (신규 VPC 설계 안 함)
- DB: RDS `db.t4g.micro`, MySQL 8.0
- 보안 그룹: RDS는 앱 EC2 보안 그룹에서 오는 3306만 허용, EC2는 인바운드 전부 폐쇄(퍼블릭 포트 없음)
- 네트워크 접근: **Tailscale**로 알파 테스터에게만 접근 허용 (`tailscale serve`로 HTTPS 인증서 자동 발급), 퍼블릭 오픈 없음
- CI/CD: GitHub Actions에서 `mvnw verify` → Docker 빌드 → ECR push. 인증은 OIDC 방식(`aws-actions/configure-aws-credentials`), 장기 액세스 키 미사용
- 시크릿 관리: EC2 컨테이너는 IAM 역할로 AWS Secrets Manager에서 DB 비밀번호 등을 조회 (평문 금지)
- 관측성: 앱 로그 stdout → CloudWatch Logs, Actuator는 `/actuator/health`만 노출
- 브랜치/배포 권한: Claude Code는 push/PR 생성까지만 수행, 실제 인프라 리소스 생성(EC2 키페어, RDS 비밀번호, 보안그룹 승인)과 PR 머지는 사람이 직접 수행

## Alternatives Considered
- Option A: CDK + Amplify (이전 project-nakushi ADR-004) — Next.js 스택 폐기와 함께 폐기, Spring Boot 컨테이너 배포에는 맞지 않음
- Option B: AWS App Runner (퍼블릭 배포 경로) — 알파 단계는 소수 테스터 대상이라 접근 통제가 더 단순한 Tailscale 경로를 선택, 공개 베타 전환 시 재검토
- Option C: Kubernetes(EKS) — MVP/알파 규모에는 오버스펙으로 판단해 보류

## Consequences
- Pros: 퍼블릭 인바운드 포트가 전혀 없어 알파 단계 보안 리스크가 낮음, EC2 단일 인스턴스라 비용이 예측 가능하고 낮음
- Cons: CDK 같은 IaC 도구를 쓰지 않아 인프라 변경 이력이 코드로 남지 않음 (콘솔/CLI 수동 설정에 의존) — 향후 재현성 문제 가능
- Risks: 공개 베타로 확장 시 Tailscale 경로를 App Runner 등으로 재설계해야 함. EC2 단일 인스턴스라 장애 시 단일 장애점(SPOF)

## Rollback Plan
문제 발생 시 EC2 인스턴스 재기동/재생성으로 대응 (상태는 RDS에 분리되어 있어 EC2는 무상태로 취급 가능). 배포 실패 시 이전 ECR 이미지 태그로 롤백. 공개 베타 전환 시점에 IaC 도구(CDK/Terraform) 도입을 재검토.
