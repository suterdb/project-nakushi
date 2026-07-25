# ADR-005 — Frontend

- Date: 2026-07-26
- Status: Accepted
- Scope: Incubation: Linet

## Context

`spec.md`에 화면 목록은 정의돼 있었지만 FE 기술 스택은 어디에도 결정된 바가 없었다. `kamilmazurek/hexagonal-architecture-template`(ADR-001)은 순수 REST API 백엔드 템플릿이라 FE를 포함하지 않는다. ADR-004에서 알파 배포 경로를 "EC2 인바운드 전부 폐쇄, Tailscale 경유"로 이미 확정했기 때문에, FE를 어떻게 분리하든 이 보안 모델과 충돌하지 않아야 한다.

## Decision

**React 기반 SPA를 BE와 완전히 분리된 코드/기술스택으로 개발하되, 배포는 알파 단계 동안 같은 인프라에 묶어 간다.**

- FE는 `suterdb/Linet` 레포 내 `/frontend` 디렉토리에 위치 (모노레포, 별도 레포 아님)
- FE는 BE를 오직 REST API(`spec.md`의 API list)로만 호출한다 — 서버사이드 렌더링/템플릿 결합 없음. 이렇게 짜야 추후 배포를 분리해도 FE 코드 변경 없이 API 엔드포인트 설정만 바꾸면 된다
- 알파 단계 배포: FE는 정적 빌드 산출물로 만들어 같은 EC2 인스턴스에서 nginx가 서빙한다 — `/`는 FE 정적 파일, `/api/*`는 Spring Boot로 리버스 프록시. ADR-004의 "퍼블릭 포트 없음, Tailscale 경유" 보안 모델은 그대로 유지된다
- 빌드 툴체인(Vite 등)과 상태관리 라이브러리 선택은 이 ADR 범위가 아니며, 구현 착수 시점에 결정한다

## Alternatives Considered
- Option A: Thymeleaf 등 서버사이드 렌더링으로 BE와 결합 — 추후 배포 분리 목표와 상충해 폐기
- Option B: 처음부터 별도 레포(`suterdb/linet-fe`)로 분리 — 알파 단계는 배포가 어차피 한 인프라에 묶여 있어 별도 레포/CI 파이프라인 오버헤드만 커짐, 보류
- Option C: 처음부터 FE를 Vercel/S3+CloudFront 등 퍼블릭 호스팅에 배포 — ADR-004의 "퍼블릭 포트 없음" 원칙과 충돌(BE를 인터넷에 노출해야 함), 보류. 공개 베타 전환 시점에 재검토
- Option D: Vue/Svelte — 생태계/자료가 React 대비 부족하다고 판단해 보류

## Consequences
- Pros: FE/BE가 코드·기술스택 레벨에서 독립적이라 각자 개발/교체가 쉬움, 추후 배포 완전 분리 시 FE 코드 변경이 거의 없음(API 엔드포인트 설정만 교체)
- Cons: nginx 리버스 프록시 설정이 추가 작업으로 필요(Dockerfile/배포 스크립트 변경), 모노레포라 CI 파이프라인에서 FE/BE 빌드를 분리 트리거해야 함
- Risks: 배포 분리 시점에 CORS 설정이 새로 필요해짐(현재는 같은 오리진이라 불필요). 인증 없는 알파 단계와 달리 공개 베타 전환 시 CORS+JWT를 함께 설계해야 함

## Rollback Plan
FE는 BE와 API 계약(`spec.md`)만 지키면 되므로, 프레임워크를 통째로 갈아엎어도 BE에 영향 없음. 레포 분리가 필요해지면 `git subtree split` 등으로 `/frontend`만 별도 레포로 추출 가능.
