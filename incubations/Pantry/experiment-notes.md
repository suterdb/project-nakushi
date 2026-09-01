# Experiment Notes — Pantry

## Hypotheses to test

- H1: 경량 모델(Haiku급) + 프롬프트 튜닝만으로 재료 분류(필수/대체/생략) 품질이 실용적 수준에 도달한다.
- H2: 사용자는 "내 재료 기반 변환 레시피"를 받았을 때 실제로 요리를 실행하는 비율이 높아진다.
- H3: 생략 가능 재료 컨펌 UX(Y/N)가 사용자에게 부담이 아닌 참여감으로 느껴진다.

## Experiments

- E1: 동일한 레시피 10개에 대해 Haiku / Sonnet 결과를 비교 — 품질 차이가 실용 임계점 이내인지 검증
- E2: 시스템 프롬프트 버전 A/B 비교 — 재료 컨텍스트 주입 방식에 따른 분류 정확도 차이 측정

## Open Questions

- 레시피 소스를 사용자 직접 입력 외에 어떻게 확장할 것인가 (외부 API vs. AI 웹 검색)
- 쇼핑 링크 제휴(쿠팡 파트너스 등) 실현 방안
- 잔량 추적 UX: 레시피 완료 후 재료 차감을 어떻게 UX적으로 처리할 것인가
- 프론트엔드 스택: Next.js SaaS 보일러플레이트 활용 가능성

## Next Actions (small)

1. Haiku 모델로 재료 분류 프롬프트 초안 작성 및 10개 레시피 수동 평가
2. MVP 프론트엔드 스택 결정 (Next.js 확정 여부)
3. 세션 기반 재료 저장 방식 설계 (로컬스토리지 vs. 서버 세션)

## Log (dated)

### 2026-06-18

- pantry-incubation-draft.md 기반으로 인큐베이션 초기화 완료
- raw-plan.md, input.md, problem.md, mvp-scope.md 생성
- Stage 00 (Problem Defined) 상태로 시작