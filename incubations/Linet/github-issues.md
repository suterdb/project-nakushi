# GitHub Issues Breakdown — Linet

총 11개 이슈. VS-01 완료를 기준으로 그룹화.

---

## Group A — 인프라 (Phase 1)

### Issue 1: CDK 프로젝트 초기화
**Labels:** `infra`, `linet`
**Description:**
- `/infra` 디렉토리에 AWS CDK TypeScript 프로젝트 생성
- `shared-stack.ts`: VPC, RDS PostgreSQL (t3.micro)
- `linet-stack.ts`: Amplify 앱 연결
- `cdk bootstrap` + `cdk deploy` 동작 확인

### Issue 2: Prisma 초기 스키마 + 마이그레이션
**Labels:** `db`, `linet`
**Depends on:** Issue 1
**Description:**
- `schema.prisma` 작성 (User, Post — VS-01 최소)
- `prisma migrate dev` → staging DB 적용
- 인덱스: `Post.createdAt DESC`

### Issue 3: Amplify 배포 파이프라인 연결
**Labels:** `infra`, `linet`
**Depends on:** Issue 1
**Description:**
- Amplify 앱 → GitHub `feature/Linet` 브랜치 연결
- 환경변수 주입 (DATABASE_URL, BEDROCK_REGION 등)
- 빌드 성공 확인

---

## Group B — VS-01: 콘텐츠 작성 + 피드 (Phase 2)

### Issue 4: 사용자 생성 API
**Labels:** `backend`, `linet`, `vs-01`
**Depends on:** Issue 2
**Description:**
- `POST /api/users` — 핸들 입력으로 사용자 생성
- 핸들 중복 검사
- Alpha: 비밀번호 없음, 쿠키 세션

### Issue 5: 콘텐츠 작성 API
**Labels:** `backend`, `linet`, `vs-01`
**Depends on:** Issue 2
**Description:**
- `POST /api/posts`
- 140자 초과 시 400 반환
- 작성 후 post 반환

### Issue 6: 피드 조회 API
**Labels:** `backend`, `linet`, `vs-01`
**Depends on:** Issue 5
**Description:**
- `GET /api/feed?cursor=&limit=20`
- 최신순 정렬, 커서 기반 페이지네이션
- `created_at` 인덱스 활용

### Issue 7: 피드 UI — PostInput 컴포넌트
**Labels:** `frontend`, `linet`, `vs-01`
**Description:**
- 140자 카운터 포함 입력창
- 전송 버튼 → `POST /api/posts` 호출
- 전송 후 입력창 초기화

### Issue 8: 피드 UI — FeedList + PostCard 컴포넌트
**Labels:** `frontend`, `linet`, `vs-01`
**Depends on:** Issue 6, 7
**Description:**
- 5초 폴링으로 피드 갱신
- PostCard: 핸들 + 본문 + 멘션 수 + 상대 시간
- 커서 기반 무한 스크롤 (기본)

---

## Group C — VS-02: 태그 (Phase 3)

### Issue 9: Bedrock Haiku 태그 추천 API
**Labels:** `backend`, `linet`, `vs-02`
**Depends on:** Issue 3
**Description:**
- `POST /api/tags/suggest` — 본문 입력 → 태그 3개 추천
- Bedrock Claude Haiku 연동
- 응답 캐싱 고려 (동일 본문 중복 호출 방지)

### Issue 10: 태그 저장 + 필터링 피드
**Labels:** `backend`, `frontend`, `linet`, `vs-02`
**Depends on:** Issue 9
**Description:**
- Prisma 스키마 추가: `Tag`, `PostTag`
- 태그 클릭 → `GET /api/feed?tag=xxx`
- 태그 검색 자동완성 UI

---

## Group D — VS-03: 멘션 (Phase 4)

### Issue 11: 멘션 구현
**Labels:** `backend`, `frontend`, `linet`, `vs-03`
**Depends on:** Issue 8
**Description:**
- `>>postId` 파싱 로직
- `mentions` 테이블 저장 + `mention_count` 갱신
- 💬 버튼 클릭 → 멘션 입력창 열기
- Prisma 스키마 추가: `Mention`

---

## 우선순위 요약

```
[즉시] Issue 1 → 2 → 3 (인프라)
[VS-01] Issue 4 → 5 → 6 (백엔드) || Issue 7 → 8 (프론트)
[VS-02] Issue 9 → 10
[VS-03] Issue 11
```
