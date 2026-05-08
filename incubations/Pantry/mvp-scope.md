# MVP Scope — Pantry

## One-line MVP

Given a user's ingredient list and a recipe, classify each recipe ingredient as essential / substitutable / omittable using a lightweight AI model.

## In Scope (max 3 flows)

| Flow | User action | System behavior | Output |
|---|---|---|---|
| 1 | Enter owned ingredients | Store ingredient list in session | Ingredient list confirmed |
| 2 | Input a recipe (manual entry) | AI classifies each ingredient: essential / substitutable / omittable | Classified ingredient breakdown |
| 3 | Confirm omissions | User approves or rejects skippable items | Final adapted recipe |

## Out of Scope (not now)

- User accounts / authentication
- Ingredient quantity / stock tracking
- Recipe history persistence
- Personalized recipe feed / recommendations
- External link handling or recipe API integration
- Shopping link affiliate integration

## Validation Criteria (measurable)

- [ ] Haiku-class model correctly classifies ≥ 80% of ingredients across 10 test recipes (manual evaluation)
- [ ] At least 3 real users complete the full flow (ingredient entry → analysis → adapted recipe) without confusion
- [ ] Prompt engineering alone (no fine-tuning) achieves the quality bar

## Assumptions

- Users are willing to input ingredients manually for the MVP
- Recipe direct-input is sufficient for validation; external API not required
- Quality bar is "genuinely useful", not "perfect"

---

## 한글 버전

## 한 줄 MVP

사용자의 보유 재료 목록과 레시피를 입력받아, AI가 각 재료를 필수/대체 가능/생략 가능으로 분류한다.

## 포함 범위 (최대 3개 플로우)

| 플로우 | 사용자 행동 | 시스템 동작 | 결과 |
|---|---|---|---|
| 1 | 보유 재료 입력 | 세션에 재료 목록 저장 | 재료 목록 확인 |
| 2 | 레시피 직접 입력 | AI가 각 재료를 필수/대체/생략으로 분류 | 분류된 재료 목록 반환 |
| 3 | 생략 재료 컨펌 | 사용자가 생략 가능 항목 승인/거부 | 최종 변환 레시피 제공 |

## 제외 범위

- 회원제/인증
- 재료 잔량 추적
- 레시피 히스토리 저장
- 개인화 추천 피드
- 외부 링크 처리 / 레시피 API 연동
- 쇼핑 링크 제휴

## 검증 기준 (측정 가능)

- [ ] Haiku급 모델이 테스트 레시피 10개 중 ≥80% 재료를 올바르게 분류
- [ ] 실제 사용자 3명 이상이 전체 플로우(재료 입력 → 분석 → 변환 레시피) 완료
- [ ] 파인튜닝 없이 프롬프트 엔지니어링만으로 품질 기준 달성

## 가정

- 사용자는 MVP에서 재료를 직접 입력할 의사가 있다
- 레시피 직접 입력 방식이 검증에 충분하다
- 품질 기준은 "완벽함"이 아닌 "실제로 유용한 수준"이다
