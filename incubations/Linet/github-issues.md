# GitHub Issues — Linet

`implementation-plan.md`의 VS-01~04를 실행 이슈로 분해한 것. 실제 코드가 `suterdb/Linet`(별도 리포)에 있으므로 이슈도 그쪽에 생성했다. 이 파일은 인덱스/링크만 유지한다.

## 이력
- 구 스택(Next.js/Prisma/Amplify/Bedrock) 기준 이슈 `project-nakushi#6~#15`는 2026-07-26 스택/기획 전환에 따라 전부 close (사유 코멘트 남김). `project-nakushi#5`(CDK 초기화)는 이미 완료 상태로 closed 유지.

## VS-01 — 작성 피드 최소 흐름
- [#3 User/Content/HiddenContent 스키마 + Flyway V1](https://github.com/suterdb/Linet/issues/3)
- [#4 POST /api/writes, GET /api/feed/writes API](https://github.com/suterdb/Linet/issues/4)
- [#5 컨텐츠 삭제(작성자)/숨김(소비자) API](https://github.com/suterdb/Linet/issues/5)
- [#6 작성 피드 프론트 UI](https://github.com/suterdb/Linet/issues/6)

## VS-02 — 태그 + 공감
- [#7 Tag/ContentTag/Like 스키마 + Flyway V2](https://github.com/suterdb/Linet/issues/7)
- [#8 LlmTaggingPort 인터페이스 + 임시 어댑터](https://github.com/suterdb/Linet/issues/8)
- [#9 좋아요 토글 + 태그 필터/자동완성 API](https://github.com/suterdb/Linet/issues/9)

## VS-03 — 멘션
- [#10 Mention 스키마 + 멘션 작성/목록 API](https://github.com/suterdb/Linet/issues/10)

## VS-04 — 이슈 피드
- [#11 RSS 수집 배치 + LLM 요약 연동](https://github.com/suterdb/Linet/issues/11)
- [#12 이슈 피드 API + 이슈 탭 UI](https://github.com/suterdb/Linet/issues/12)

## Infra
- [#13 Phase 1 마무리 — H2→MySQL, OpenAPI-first 제거 확인](https://github.com/suterdb/Linet/issues/13)
- [#14 CI/CD 파이프라인](https://github.com/suterdb/Linet/issues/14)
