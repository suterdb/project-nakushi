# Vertical Slice 01 — 콘텐츠 작성 + 피드 노출

## 목표

사용자가 한 줄을 작성하면 실시간 피드에 즉시 반영된다.
이 슬라이스 하나로 Linet의 핵심 가치(작성 → 공유)를 검증할 수 있다.

## 범위

**포함:**
- 최소 사용자 생성 (핸들만, 비밀번호 없음 — Alpha 한정)
- 콘텐츠 작성 (140자 제한)
- 피드 조회 (최신순, 5초 폴링)
- 기본 UI (입력창 + 피드 카드)

**제외:**
- LLM 태그 추천 (VS-02)
- 멘션 (VS-03)
- 인증/로그인 (Alpha는 핸들 기반 세션)

---

## API 명세

### `POST /api/posts`

```typescript
// Request
{ body: string }          // 1–140자

// Response 200
{ id: string, body: string, handle: string, created_at: string }

// Response 400
{ error: "body must be 1–140 characters" }
```

### `GET /api/feed`

```typescript
// Query
?cursor=<created_at>&limit=20   // 커서 기반 페이지네이션

// Response 200
{
  posts: Array<{
    id: string,
    body: string,
    handle: string,
    mention_count: number,
    created_at: string
  }>,
  next_cursor: string | null
}
```

---

## Prisma 스키마 (VS-01 최소)

```prisma
model User {
  id        String   @id @default(cuid())
  handle    String   @unique
  posts     Post[]
  createdAt DateTime @default(now()) @map("created_at")
}

model Post {
  id           String   @id @default(cuid())
  body         String   @db.VarChar(140)
  mentionCount Int      @default(0) @map("mention_count")
  user         User     @relation(fields: [userId], references: [id])
  userId       String   @map("user_id")
  createdAt    DateTime @default(now()) @map("created_at")

  @@index([createdAt(sort: Desc)])
}
```

---

## UI 컴포넌트

```
<FeedPage>
  <PostInput />          ← 입력창 (140자 카운터 포함)
  <FeedList />           ← 5초 폴링, 최신 포스트 목록
    <PostCard />         ← 핸들 + 본문 + 멘션 수 + 시간
```

---

## 완료 기준

- [ ] `POST /api/posts` 동작 (140자 초과 시 400)
- [ ] `GET /api/feed` 동작 (최신순 20개, 커서 페이지네이션)
- [ ] 5초 폴링으로 새 포스트 자동 반영
- [ ] staging 환경에서 E2E 동작 확인
- [ ] 입력창 → 전송 → 피드 반영까지 3초 이내

## 예상 소요

1–3일 (인프라 완료 후)
