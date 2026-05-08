# Experiment Notes — Pantry

## Hypotheses to test

- H1: A Haiku-class model with a well-designed system prompt can classify recipe ingredients (essential / substitutable / omittable) at a quality level that is genuinely useful — without fine-tuning.
- H2: Manual recipe entry is sufficient for MVP validation; external recipe sourcing is not required at this stage.

## Experiments

- E1: Design and iterate on a system prompt that receives (owned ingredients, recipe ingredient list) and outputs classified results. Evaluate against 10 manually selected test recipes.
- E2: Run 3 real-user sessions end-to-end (ingredient entry → AI analysis → adapted recipe) and observe where confusion or errors occur.

## Open Questions

- Recipe source strategy: direct input vs. external API vs. AI web search — which is best for post-MVP?
- Shopping link affiliate: Coupang Partners or equivalent — feasibility and integration path?
- Stock tracking UX: how to handle ingredient quantity decay after recipe use without introducing too much friction?
- Frontend stack: Next.js SaaS boilerplate — is it the right fit for this project?

## Next Actions (small)

1. Write system prompt v1 for ingredient classification and run against 5 test recipes manually.
2. Define the quality rubric for "genuinely useful" (what counts as a correct classification?).
3. Decide on recipe input method for MVP (lean toward direct input; validate assumption in E2).

## Log (dated)

### 2026-05-08

- Pantry incubation created from draft. Problem, MVP scope, and open questions transferred from planning doc.
- Key technical risk identified: prompt quality for ingredient classification.

---

## 한글 버전

## 검증할 가설

- H1: Haiku급 모델 + 잘 설계된 시스템 프롬프트만으로, 재료 분류(필수/대체/생략) 품질이 실제로 유용한 수준이다. 파인튜닝 불필요.
- H2: 레시피 직접 입력 방식이 MVP 검증에 충분하다. 외부 레시피 소스는 이 단계에서 불필요하다.

## 실험

- E1: 보유 재료 + 레시피 재료 목록을 입력받아 분류 결과를 출력하는 시스템 프롬프트를 설계하고 반복 개선. 10개 테스트 레시피로 평가.
- E2: 실제 사용자 3명과 전체 플로우(재료 입력 → AI 분석 → 변환 레시피)를 진행하고, 혼란이나 오류 발생 지점 관찰.

## 오픈 이슈

- 레시피 소스 확보 방식: 직접 입력 / 외부 API / AI 웹 검색 — 포스트 MVP에 적합한 방식은?
- 쇼핑 링크 제휴: 쿠팡 파트너스 등 — 실현 가능성 및 연동 방안?
- 잔량 추적 UX: 레시피 사용 후 재료 감산을 어떻게 처리할 것인가?
- 프론트엔드 스택: Next.js SaaS 보일러플레이트 적합성 검토.

## 다음 액션

1. 재료 분류용 시스템 프롬프트 v1 작성 후 테스트 레시피 5개에 수동 적용.
2. "실제로 유용한 수준"의 품질 기준(루브릭) 정의.
3. MVP 레시피 입력 방식 결정 (직접 입력 우선, E2에서 가정 검증).

## 로그

### 2026-05-08

- 기획 초안에서 Pantry 인큐베이션 온보딩. 문제 정의, MVP 범위, 오픈 이슈 이전 완료.
- 핵심 기술 리스크: 재료 분류 프롬프트 품질.
