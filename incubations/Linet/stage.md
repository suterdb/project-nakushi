# Stage Status — Linet

CURRENT_STAGE: Stage 10 — MVP Defined
NEXT_STAGE: Stage 20 — Technical Baseline Fixed

## Required files (per current stage)
- [x] problem.md
- [x] mvp-scope.md
- [x] experiment-notes.md
- [x] stage.md

## Exit criteria check (Stage 10)
- [x] MVP scope <= 3 core flows — evidence: `mvp-scope.md`의 "Flow 1: 이슈 피드 수집 및 노출 / Flow 2: 사용자 작성 및 피드 노출 / Flow 3: 반응 (공감/멘션)" — 정확히 3개
- [x] out-of-scope list exists — evidence: `mvp-scope.md` "Out-of-Scope (MVP에서 제외)" 섹션에 5개 항목 (크롤링, 커뮤니티 소스 확장, 프로필/DM/알림/팔로우, 이미지업로드, 모바일 앱)
- [~] validation criteria is measurable — evidence: `mvp-scope.md` "검증 범위 (폐쇄 알파 기준)"에 3개 확인 항목이 있으나 수치 임계값(%) 없이 정성적 yes/no 형태. `experiment-notes.md` Log 2026-07-26에 "이번 라운드 목표는 커뮤니티 화제성 가설이 아니라 폐쇄 알파를 통한 파이프라인/UX 검증"이라고 의도적으로 정성 평가로 좁힌 이유가 기록되어 있음 — 완전 충족은 아니나, 사용자가 명시적으로 선택한 트레이드오프이므로 보류 아님

## Next artifacts (ordered)
- [ ] ADR set (tech stack — Spring Boot 보일러플레이트 기준)
- [ ] ADR set (architecture, data model, deployment)

## Open questions
- 재시작 사유: 스프링 부트 보일러플레이트 기반 빠른 MVP 검증으로 방향 전환 예정 — 이전 Stage 10~30 산출물(문제정의/MVP스코프/ADR 4종/구현계획/수직슬라이스/이슈목록)은 삭제하고 처음부터 다시 진행
- 기존 GitHub Issues [#5–#15](https://github.com/suterdb/project-nakushi/issues?q=is%3Aissue+label%3Alinet)는 그대로 유지 (닫지 않음) — 재검토 대상
- 기존 `/infra` CDK 코드(Next.js + Bedrock + RDS 기반)는 그대로 유지 — 새 기술 방향(Spring Boot)과 맞는지 재검토 필요

## Decision log (links)
- (리셋됨 — 이전 ADR-001~004는 삭제됨, 새 기술 결정 시 재작성)

## Last updated
- 2026-07-26 (Stage 00 → Stage 10 완료)
