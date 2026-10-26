---
name: api-testing
description: Autonomous, context-aware API testing and closed-loop verification workflow for modern backend APIs (NestJS/Node.js). Features automatic stack detection, impact analysis, dual-layer state validation, and self-healing test/code repair.
---

# 🤖 Autonomous API Testing & Verification Workflow

This skill defines an end-to-end, self-healing testing workflow for backend APIs. Its mission is to verify that business logic agreed upon in the conversation actually works in the running application and database, free of regressions or unhandled edge cases.

---

## 🔁 The Closed-Loop Verification Lifecycle

```
[1. Stack & Context Discovery] ──► [2. Blast Radius & Impact Analysis]
              ▲                                      │
              │                                      ▼
[5. Self-Healing & Auto-Repair] ◄── [3. Stateful Test Scaffolding]
              ▲                                      │
              │ (On Failure)                         ▼
              └───────────────────────── [4. Dual-Layer Verification]
```

---

## Phase 1: Stack & Context Discovery

Before writing or running any test, inspect the workspace dynamically:

1. **Stack & Paradigm Detection**:
   - **Framework**: Locate controllers and route definitions (e.g. NestJS `@Controller`, Express routers, Fastify).
   - **Business Logic Layer**: Check whether the project uses **CQRS** (Commands/Queries in `packages/**/cqrs` or `src/commands/`) or **Service-oriented** architecture (`@Injectable()` services).
   - **ORM / Database**: Check for TypeORM (`EntityManager`, `BaseEntity`), Prisma (`prisma.<model>`), MikroORM, or Drizzle.
   - **Async Events**: Check for event dispatchers (Inngest `inngest.send`, BullMQ queues, EventEmitter).
2. **Conversation Intent & Acceptance Criteria**:
   - Harvest the explicit feature requirements, expected behaviors, edge cases, and error conditions agreed upon in the current conversation or implementation plan.
3. **Contract & Schema Inspection**:
   - Locate shared DTOs, Zod schemas, or validation classes.
   - Inspect required fields, allowed enums, validation pipes, and response formats.
4. **Auth & Test Credentials**:
   - Identify test authentication patterns (e.g. mock OTP services, test seed tokens, or environment credentials like `TEST_USER_TOKEN`).
   - If using OTP authentication, check mock/dev OTP services (common values: `2222`, `1111`, `0000`, or dynamic test endpoints).

---

## Phase 2: Blast-Radius & Impact Analysis

Analyze the ripple effects of recent changes before writing tests:

1. **Map Changed Files**: Run `git status -s` or check recently modified files.
2. **Trace the Dependency Chain**:
   - **Controller Layer**: Did route paths, HTTP methods, route parameters, or validation pipes change?
   - **Logic Layer**: Did command/query handlers or service methods introduce new preconditions or state machine requirements?
   - **Data Layer**: Did entity schemas, relations, foreign keys, or unique indexes change?
   - **Worker Layer**: Are there background jobs or events triggered as side-effects?
3. **Define Test Boundary**:
   - **Target Endpoints**: The primary endpoints modified or added.
   - **Upstream Prerequisites**: Endpoints needed to create parent/relational fixtures (e.g. create org $\rightarrow$ create user $\rightarrow$ authenticate).
   - **Downstream Consumers**: Sibling or downstream endpoints that read or process the modified entity.

---

## Phase 3: Stateful Test Scaffolding & Fixture Management

Scaffold test scripts in the scratch directory (e.g. `<appDataDir>/brain/<conversation-id>/scratch/test_<feature>.ts` or `.js`):

1. **Dynamic Authentication**:
   - Execute the project's login/auth flow once and extract the session/Bearer token.
   - Cache the token for the duration of the test session to avoid redundant auth requests.
2. **Dynamic Fixtures (Never Hardcode IDs)**:
   - Database seeders generate fresh UUIDs/ULIDs. **Never hardcode static foreign keys or IDs**.
   - Query list endpoints first (e.g. `GET /locations`, `GET /users`) to grab an existing ID dynamically.
   - If the list is empty, programmatically call the corresponding creation endpoint (`POST`) to create the dependency on the fly.
3. **Collision Prevention & Idempotency**:
   - Always append timestamps or random suffixes/ULIDs to unique fields (e.g. `test_${Date.now()}@example.com`, `ITEM_${Date.now()}`).
   - Ensure the test suite can be run multiple times consecutively without throwing "duplicate key" or "unique constraint" errors.
4. **Session State Persistence**:
   - Store created fixture IDs in a local scratch state file (e.g. `scratch/test_state.json`). Subsequent test executions can resume using existing test entities without re-seeding from scratch.

---

## Phase 4: Dual-Layer Verification

Verify both the outward HTTP contract and the underlying system state:

### Layer 1: HTTP Contract & API Surface
- **Exact Status Codes**: Assert expected codes (`201` for creations, `200` for reads/updates, `204` for deletions, `400` for validation rejections, `401`/`403` for auth checks, `404` for not found).
- **Runtime Schema Validation**: Validate that returned JSON keys match the DTO/schema contract and required fields are not `null` or `undefined`.
- **Negative & Edge Cases**: Send malformed payloads (missing fields, wrong data types, invalid enums) to ensure the API safely rejects them with structured `400 Bad Request` rather than unhandled `500` errors.

### Layer 2: Database & State Machine Truth
- **Strict State Transitions**: If the entity follows a state machine (e.g. `DRAFT -> PENDING -> APPROVED -> ACTIVE`), verify that intermediate states cannot be bypassed and transition sequentially.
- **Side-Effect Verification**:
  - Check that database rows were actually created or updated with correct relational foreign keys.
  - For numeric counters, balances, or stock, assert **relative changes** (e.g. `finalBalance === initialBalance - deduction`) rather than absolute values to remain resilient against accumulated database state.
- **Rollback Verification**: For operations that fail mid-flight, verify that transactions rolled back cleanly and no orphan records remain.

---

## Phase 5: Self-Healing & Closed-Loop Repair Algorithm

When a test step fails, execute this automated triage tree:

```
Test Failed
  ├── Step 1: Capture Raw Error
  │     ├── Log response error payload: `e.response?.data`
  │     └── If HTTP 500: Inspect backend server logs or terminal immediately to get the exact stack trace
  │
  ├── Step 2: Classify Root Cause
  │     │
  │     ├── CATEGORY A: Test Script Defect
  │     │     Examples: Outdated request payload schema, wrong header, missing query param,
  │     │               hardcoded non-existent ID, or race condition in test assertion.
  │     │     Action: Auto-repair the test script, adjust wait times, and re-execute.
  │     │
  │     ├── CATEGORY B: Implementation Code Defect
  │     │     Examples:
  │     │     • Missing handler/provider in module (e.g. CommandHandlerNotFoundException).
  │     │       Fix: Register missing handlers/services in the NestJS module's `providers` array.
  │     │     • Unhandled DB exception / constraint violation in transaction.
  │     │       Fix: Wrap transaction logic, check nullability/FK checks, throw standard HTTP exceptions.
  │     │     • Missing DTO validation decorator or unhandled edge case.
  │     │       Fix: Update DTO or service/handler adhering to project style guide and rulebooks.
  │     │     Action: Modify implementation files adhering to repository rules.
  │     │
  │     └── CATEGORY C: State Accumulation Defect
  │           Examples: Test assumed clean database but prior test runs populated rows.
  │           Action: Switch to delta/relative assertions or isolate using a fresh unique ULID.
  │
  └── Step 3: Re-execute & Re-verify
        Repeat until the entire verification flow passes cleanly with zero errors.
```

---

## Phase 6: Code Quality Standards During Repairs

When auto-repairing backend implementation code:
1. **Preserve Architecture**: Respect the project's established paradigm (e.g. CQRS separation, transactional entity managers, repository pattern, or service layer).
2. **Built-in Exceptions**: Throw framework-standard HTTP exceptions (e.g. `BadRequestException`, `NotFoundException`). Avoid untyped or generic errors.
3. **Single Source of Truth**: Keep DTOs and contracts centralized. Do not define duplicate ad-hoc payload types in controllers.
4. **Regression Prevention**: After fixing a defect, re-run both the failed test and all previously passing tests in the affected blast radius.
