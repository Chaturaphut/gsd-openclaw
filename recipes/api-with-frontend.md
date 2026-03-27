# Recipe: API with Frontend Integration

## Overview
This recipe covers the full-stack workflow for building an API endpoint and its corresponding frontend integration in a single GSD milestone. This pattern is ideal for CRUD features, dashboard widgets, and complex user flows.

## Phase 1: API Setup (Backend)
- **Requirements**: Define the API contract (endpoint, method, request/response schema, authentication).
- **Research**: Check existing DB models, middleware patterns, and security best practices.
- **Plan**:
  - `Task 1.1`: Create/Update DB model.
  - `Task 1.2`: Implement Controller logic.
  - `Task 1.3`: Register Route and Middleware.
  - `Task 1.4`: Unit test the endpoint.
- **QA**: Verify API response against the requirements schema.

## Phase 2: Frontend Integration
- **Requirements**: Map the API response to the frontend state management and UI components.
- **Research**: Check existing component patterns, state management (Redux/Zustand), and styling.
- **Plan**:
  - `Task 2.1`: Create API service/hook.
  - `Task 2.2`: Implement state management logic.
  - `Task 2.3`: Build UI components and wire up to state.
  - `Task 2.4`: Implement loading and error states.
- **QA**: Verify UI rendering with both successful and failed API responses.

## Key Checkpoints
1.  **Contract Alignment**: In Phase 1, the backend agent *must* export the API schema (e.g., OpenAPI or `types.ts`).
2.  **Wave-Based Execution**: In Phase 2, Task 2.1 (API hook) can run in the same wave as Task 2.3 (UI layout) if the schema is already known.
3.  **Cross-Phase QA**: After Phase 2 is complete, run the Phase 1 API tests again to ensure no regressions were introduced.

## Handoff Pattern
Use `HANDOFF.json` to pass the API endpoint URL and schema types from the Backend agent to the Frontend agent.

```json
{
  "phase": "api-setup",
  "status": "complete",
  "decisions": [
    {
      "id": "API-001",
      "summary": "Used snake_case for response fields to match legacy DB"
    }
  ],
  "exports": {
    "api_endpoint": "/api/v1/orders",
    "schema_file": "src/types/orders.ts"
  }
}
```
