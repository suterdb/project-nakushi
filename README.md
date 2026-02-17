# 🏝 Project Nakushi

> "Nakushi is not the destination.\
> It is the shore where I prepare before crossing the sea."

------------------------------------------------------------------------

# 1. What is Project Nakushi?

Project Nakushi is a personal product incubator.

It does not exist to build a single product.\
It exists to build the capability to build any product.

Nakushi is where ideas are tested, shaped, validated, and either spun
off --- or consciously abandoned.

------------------------------------------------------------------------

# 1. Project Nakushi란?

Project Nakushi는 개인 웹 서비스 인큐베이터이다.

하나의 제품을 만들기 위한 프로젝트가 아니다.\
어떤 제품이든 만들어낼 수 있는 상태를 만드는 프로젝트다.

Nakushi는 아이디어를 실험하고, 다듬고, 검증하고,\
살아남은 것만 독립시키는 공간이다.

------------------------------------------------------------------------

# 2. Philosophy / 철학

Progress is not code.\
Progress is validated learning and deliberate decisions.

진짜 진전은 코드가 아니다.\
진짜 진전은 검증된 학습과 명확한 결정이다.

If it is not recorded, it did not meaningfully happen.\
기록되지 않은 것은 의미 있게 존재하지 않은 것이다.

------------------------------------------------------------------------

# 3. Repository Structure

/ops\
  /decisions\
  /reports\
/prompts\
/incubations

------------------------------------------------------------------------

# 4. Core Rules / 핵심 규칙

## ADR (/ops/decisions)

Create when: - Architecture or structure is fixed - Trade-offs are
chosen - Tools are finalized - Scope boundaries are defined

Must include: - Context - Decision - Alternatives - Consequences -
Rollback Plan

Rollback이 없다면 결정은 미성숙하다.

------------------------------------------------------------------------

## Weekly Report (/ops/reports)

Created once per week. No exception.

Must include: - Done - Doing - Blocked - Next Top 3 - Risks / Debt

------------------------------------------------------------------------

## Incubations (/incubations)

Each idea gets its own directory.

Files: - problem.md - mvp-scope.md - experiment-notes.md

Each must fit within one page.

------------------------------------------------------------------------

## Prompts (/prompts)

Prompts are versioned assets.

-   Store as files
-   Commit reason when modified
-   AI reads prompt files, not ad-hoc chat

Prompts are infrastructure.
