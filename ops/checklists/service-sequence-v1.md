# Service Build Sequence v1

> **규칙**: 이 시퀀스를 따르지 않는 프로젝트는 인정하지 않는다.
> 새 서비스는 반드시 `./scripts/new-service.sh <name>` 으로 생성한다.

---

## Stage 0 — 생성

- [ ] `./scripts/new-service.sh <service-name>` 으로 생성 (수동 생성 금지)
- [ ] `incubations/<name>/` 디렉토리 확인
- [ ] `stage.md` 존재 확인

---

## Stage 1 — 1페이지 정의 (= Stage 00: Problem Defined)

- [ ] `incubations/<name>/problem.md` 작성
  - 문제 정의 (1페이지 이내)
  - 타겟 사용자 정의
  - 성공 기준 정의 (검증 기준)

**Exit 기준**: problem statement가 1페이지에 들어오고, 성공 기준이 존재한다.

---

## Stage 2 — 유스케이스 3개 정의 (= Stage 10: MVP Defined)

- [ ] `incubations/<name>/mvp-scope.md` 작성
  - 핵심 플로우 3개 이하 (input → store → output)
  - out-of-scope 목록 존재
  - 검증 기준이 측정 가능
- [ ] `incubations/<name>/experiment-notes.md` 작성
  - 핵심 가설 정의
  - 검증 방법 정의

**Exit 기준**: MVP 범위 ≤ 3개 핵심 플로우, 검증 기준 명확.

---

## Stage 3 — 도메인 초안 (= Stage 20: Technical Baseline Fixed)

- [ ] `ops/decisions/ADR-001-tech-stack.md` 작성
- [ ] `ops/decisions/ADR-002-architecture.md` 작성
- [ ] `ops/decisions/ADR-003-data-model.md` 작성 (엔티티 5개 이하)
- [ ] `ops/decisions/ADR-004-deployment.md` 작성

**Exit 기준**: 선택된 스택 명시, 위험 결정에 롤백 노트 존재, 최소 배포 계획 존재.

---

## Stage 4 — API 1개 End-to-End 구현 (= Stage 30: Execution Ready)

- [ ] `incubations/<name>/implementation-plan.md` 작성
- [ ] `incubations/<name>/vertical-slice-01.md` 작성
  - 요청 → DB → 응답 흐름 완성
  - 로컬 실행 확인
- [ ] GitHub Issues 작성 (8–12개)

**Exit 기준**: vertical slice 1–3일 내 완성 가능, issue 목록이 plan에 매핑됨.

---

## Stage 5 — 실행 자동화 (= Stage 40: Active Build)

- [ ] `run.sh` 또는 `Makefile` 작성
- [ ] `ops/reports/YYYY-W##.md` 주간 리포트 시작
- [ ] 최소 1개의 vertical slice 머지

**Exit 기준**: 실제 사용자 또는 proxy 테스트로 검증 실행, 방향 결정(spin-off / continue / archive).

---

## Stage 6 — 최소 배포 (= Stage 40 계속)

- [ ] `incubations/<name>/docs/deploy.md` 작성
  - 배포 환경 기록
  - 배포 명령 기록
  - 롤백 방법 기록

---

## Stage 7 — 회고 및 기록 (= Stage 90 or 계속)

- [ ] `ops/reports/` 에 daily 기록 생성
- [ ] `./scripts/snapshot.sh` 실행
- [ ] 방향 결정: spin-off → 새 repo, 계속 → Stage 40 반복, 종료 → `archive.md`

---

## 운영 원칙 (체크리스트 외)

1. 새 서비스는 반드시 스크립트로 생성한다.
2. 매일 최소 1회 `snapshot.sh` 실행.
3. 매일 `daily-report.sh` 실행.
4. AI 프롬프트는 `prompts/` 에 버전 관리.
5. 결정은 반드시 ADR로 기록.
