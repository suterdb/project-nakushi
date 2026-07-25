# Spec — Linet

## One-line summary
RSS 기반 실시간 이슈 피드(1차: KBO 뉴스)와 사용자 작성 한 줄 피드를 태그·멘션·공감으로 엮은 Spring Boot 기반 폐쇄 알파 서비스.

## Screens
| Screen | Purpose | Key elements |
|---|---|---|
| 메인 피드 (이슈 탭) | RSS로 수집된 이슈를 한 줄로 훑어보는 진입점 | 상단 GNB 없음, 카드: `#태그 내용 ❤️N 💬N`, 작성 탭으로 전환하는 탭 UI |
| 메인 피드 (작성 탭) | 사용자가 직접 쓴 한 줄 피드 | 카드: `#태그 내용 ❤️N 💬N ✖️`, 하단 고정 입력창 |
| 태그 필터 피드 | 특정 태그 클릭 시 해당 태그 컨텐츠만 필터링 | 태그 검색/자동완성, 필터링된 카드 목록 |
| 멘션 작성 팝업 | 💬 클릭 시 해당 컨텐츠를 멘션하는 입력창 | 멘션 코드(`>><contentID>`) 자동 삽입, 140자 입력, LLM 태그 추천 |
| 멘션 목록 팝업 | 멘션 숫자 클릭 시 해당 컨텐츠를 멘션한 목록 표시 | 멘션한 컨텐츠 리스트 (펼치기 전 원문 비노출) |

두 탭(이슈/작성)은 완전히 분리된 피드로 취급한다 — 통합 피드 옵션은 채택하지 않음.

## API list
| Method | Path | Purpose | Request | Response |
|---|---|---|---|---|
| GET | `/api/feed/issues` | 이슈 피드 목록 (최신순) | `?cursor=&limit=` | 카드 목록 (태그, 본문, 출처명, 좋아요/멘션 수) |
| GET | `/api/feed/writes` | 작성 피드 목록 (최신순) | `?cursor=&limit=` | 카드 목록 |
| POST | `/api/writes` | 한 줄 작성 등록 | `{deviceId, body, tags[]}` | 생성된 카드 |
| GET | `/api/tags/{tag}/feed` | 태그 기반 필터 피드 | `?cursor=&limit=` | 카드 목록 |
| GET | `/api/tags/autocomplete` | 태그 자동완성 | `?q=` | 태그 후보 목록 |
| POST | `/api/contents/{id}/like` | 공감 토글 | `{deviceId}` | 갱신된 like_count |
| POST | `/api/contents/{id}/mentions` | 멘션 작성 | `{deviceId, body, tags[]}` | 생성된 멘션 카드 |
| GET | `/api/contents/{id}/mentions` | 특정 컨텐츠를 멘션한 목록 | `?cursor=&limit=` | 멘션 카드 목록 |
| DELETE | `/api/contents/{id}` | 원본 삭제 (작성자 본인만, deviceId로 판별) | `{deviceId}` | 204 |
| POST | `/api/contents/{id}/hide` | 소비자 개인 피드에서 숨김 | `{deviceId}` | 204 |
| (내부) | RSS 수집 배치 | Spring `@Scheduled`로 마이데일리/스포츠경향 RSS 폴링 → LLM 요약·태깅 → Content(ISSUE) 저장. 주기는 10분 기본값(잠정, 조정 가능) | - | - |

## Data model (summary)
- **User**: id, device_id(익명 식별자, 쿠키/localStorage 발급) — 알파 단계는 로그인 없이 이 식별자만으로 작성자 판별·좋아요 중복 방지 처리. *추후 확장 가능: 닉네임, 로그인/인증 도입 시 이 테이블에 컬럼만 추가하고 device_id는 유지.*
- **Content**: id, type(`ISSUE`/`WRITE`), body, source_name/source_url(ISSUE만), author_id(WRITE만, FK User), like_count, created_at, deleted_at(nullable — soft delete. VS-01에서 확정: 삭제된 원글을 VS-03 멘션이 참조할 수 있어 hard delete 대신 채택)
- **Tag**: id, name
- **ContentTag**: content_id, tag_id (N:M)
- **Mention**: id, source_content_id(멘션 작성 카드), target_content_id(멘션 대상 원본)
- **Like**: id, content_id, user_id (unique(content_id, user_id) — 중복 방지 및 재클릭 취소)
- **HiddenContent**: user_id, content_id (소비자별 숨김, 원본은 그대로 존재)

## Frontend
- React SPA, BE(Spring Boot)와 코드/기술스택 완전 분리. `suterdb/Linet/frontend` 디렉토리(모노레포)에 위치
- BE는 오직 REST API(위 API list)로만 호출 — 서버사이드 렌더링 결합 없음
- 알파 배포: 정적 빌드 산출물을 같은 EC2에서 nginx가 서빙 (`/`→FE 정적파일, `/api/*`→Spring Boot 리버스 프록시). ADR-004의 "퍼블릭 포트 없음" 원칙 유지
- 배포 완전 분리(퍼블릭 CDN 등)는 공개 베타 전환 시 재검토 (ADR-005 참고)

## LLM 태깅/요약 연동
- 벤더(구체적 LLM API)는 이번 spec에서 확정하지 않는다. **외부 LLM API를 호출하는 형태**로만 구현하고, 교체 가능하도록 추상화한다.
- ADR-001/002의 Hexagonal Architecture 구조를 그대로 활용 — `application` 계층에 `LlmTaggingPort`(인터페이스)를 정의하고, `infrastructure` 계층에 특정 벤더 adapter(예: OpenAI, Bedrock, 로컬 모델 등)를 붙이는 방식. 벤더 교체 시 adapter만 갈아끼우면 되도록 한다.
- 이슈 요약(RSS 원문 → 한 줄)과 태그 추천(작성/멘션 입력 → 태그 후보) 둘 다 이 포트를 통해 처리.

## Out-of-scope (restated from mvp-scope.md)
- 크롤링 기반 수집, RSS 미제공 커뮤니티 소스 확장
- 사용자 프로필 페이지, DM, 알림, 팔로우/팔로워
- 이미지/영상 업로드, 외부 링크 직접 노출
- 모바일 앱 (웹 우선)
- 정식 로그인/인증 (알파 단계는 익명 device_id만)

## Open technical questions
- RSS 폴링 주기 10분은 잠정값 — 뉴스 발행 빈도 확인 후 `implementation-plan.md` 단계에서 조정 가능
- LLM 벤더 선정 — `implementation-plan.md`/구현 단계에서 확정 필요 (포트/어댑터 구조만 여기서 고정)
