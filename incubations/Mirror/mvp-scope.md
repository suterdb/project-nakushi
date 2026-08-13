# MVP Scope — Mirror

## One-line MVP

A single-session interface where a user pastes their own text,
and the LLM constructs a persona from it — then lets the user have a conversation with that persona.

한 줄 MVP: 사용자가 자신의 텍스트를 붙여넣으면, LLM이 페르소나를 구성하고,
사용자는 그 페르소나(나)와 단일 세션 대화를 나눈다.

## In Scope (max 3 flows)

| Flow | User action | System behavior | Output |
|---|---|---|---|
| 1 | 텍스트 붙여넣기 (일기, 메모, 대화 등) | LLM이 말투 / 가치관 / 관심사 패턴 추출 | "나" 페르소나 프로파일 생성 |
| 2 | 질문 또는 상황 입력 ("나라면 이걸 어떻게 생각했을까?") | LLM이 페르소나 기반으로 응답 생성 | 1인칭 나의 목소리로 된 답변 |
| 3 | 대화 이어가기 | 대화 맥락을 유지하며 응답 | 멀티턴 대화 세션 |

## Out of Scope (not now)

- 계정 저장 / 페르소나 영구 보존
- 다중 시점 ("과거의 나" vs "현재의 나") 비교
- 외부 데이터 연동 (카카오톡, 노션 API 등)
- 감정 분석 리포트 / 시각화
- 모바일 앱

## Validation Criteria (measurable)

- [ ] 사용자가 응답을 받은 후 "내가 할 법한 말"이라고 느끼는 경우 ≥ 60% (설문)
- [ ] 단일 세션 내 평균 3턴 이상 대화가 이어짐
- [ ] 세션 완료 후 "다시 사용하고 싶다"는 응답 ≥ 50%

## Assumptions

- 사용자는 자신의 텍스트 데이터 일부를 공유할 의향이 있다
- 500~2000단어 수준의 텍스트로 의미 있는 페르소나 구성이 가능하다
- 단일 세션(비저장)으로도 가치를 느낄 수 있다
