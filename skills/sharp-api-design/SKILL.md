---
name: sharp-api-design
description: API design quality enforcement. Covers REST API endpoint design, error handling, versioning, pagination, naming conventions, and request/response modeling. This skill should be used when the user asks to design, review, or improve an API — whether a new API from scratch or refactoring an existing one. It corrects the most common AI API design failures: inconsistent naming, mixed REST/RPC styles, broken error patterns, and pagination chaos.
agent_created: true
---

# sharp-api-design: API Design Quality

> REST APIs, endpoint design, error handling, pagination, versioning. Not GraphQL schema design, not database schema design, not RPC protocol specs.
> A bad API wastes more developer hours than bad code. Every inconsistency compounds.

---

## 0. API STYLE INFERENCE

Before designing anything, answer:

1. **Who consumes this API?** (Internal frontend team? Third-party developers? Both?)
2. **What is the primary interaction pattern?** (CRUD resources? RPC-style actions? Event-driven?)
3. **What is the expected traffic volume?** (10 requests/day or 10,000/second changes everything.)

Output a one-line read: **"Designing a \<REST / RPC-hybrid / event-driven> API for \<consumer type>, at \<traffic level>."**

---

## 1. NAMING CONSISTENCY (Highest Priority)

### 1.1 Resource Naming
- **Plural nouns** for collection endpoints: `/users`, `/orders`, `/projects`
- **Singular noun + ID** for individual resources: `/users/{id}`, `/orders/{id}`
- **No verbs in URL paths.** The HTTP method is the verb.
  - `GET /users` not `GET /getUsers`
  - `POST /users` not `POST /createUser`
- **kebab-case for multi-word resources:** `/shipping-addresses` not `/shippingAddresses` or `/shipping_addresses`

### 1.2 Action Endpoints (When CRUD Isn't Enough)
When an action doesn't map cleanly to CRUD:
- Use `/resource/{id}/action` pattern: `POST /orders/{id}/cancel`
- Never: `POST /cancelOrder` (RPC-style leaking into REST)
- Action names are verbs in the URL: `cancel`, `approve`, `archive`, `publish`

### 1.3 Field Naming in JSON
**Pick ONE convention and apply it EVERYWHERE.** No mixing.

| Convention | Example | Common in |
|---|---|---|
| camelCase | `createdAt`, `shippingAddress` | JavaScript/TypeScript ecosystems |
| snake_case | `created_at`, `shipping_address` | Python/Ruby ecosystems |

**Default: camelCase** for public APIs (the JavaScript ecosystem dominates API consumers). Use snake_case only if the entire backend stack is Python and all consumers are internal.

**Field naming rules (regardless of convention):**
- Boolean fields: `isActive`, `hasDiscount` (prefix with `is`/`has`)
- Date/time fields: `createdAt`, `updatedAt`, `deletedAt` (suffix with `At`)
- ID references: `userId` not `user_id` or just `user` (make it clear it's an ID)
- List fields: plural name (`items`, `tags`, `errors`)

---

## 2. ERROR RESPONSE STANDARD

### 2.1 The Golden Rule
**HTTP status codes communicate the outcome category. The response body communicates the specific problem.**

Never return HTTP 200 with an error body. Never return HTTP 500 for a validation error.

### 2.2 Error Response Schema
Every error response MUST follow this structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The 'email' field is required.",
    "details": [
      {
        "field": "email",
        "reason": "required",
        "message": "Email address is required to create an account."
      }
    ],
    "requestId": "req_abc123"
  }
}
```

### 2.3 Status Code Usage
| Code | When | Body Requirements |
|---|---|---|
| 200 | Success (GET, PUT, PATCH) | Full resource representation |
| 201 | Resource created (POST) | Full resource + Location header |
| 204 | Success, no content (DELETE) | Empty body |
| 400 | Validation error | `details` array with per-field errors |
| 401 | Missing or invalid auth | `code: "UNAUTHORIZED"` |
| 403 | Auth valid, but insufficient permissions | `code: "FORBIDDEN"` |
| 404 | Resource not found | `code: "NOT_FOUND"` |
| 409 | Conflict (duplicate, state conflict) | `code: "CONFLICT"` |
| 422 | Semantically invalid (valid JSON, wrong logic) | `code: "UNPROCESSABLE"` |
| 429 | Rate limited | `Retry-After` header required |
| 500 | Unexpected server error | `requestId` for debugging, no stack trace |

### 2.4 Error Code Naming
Error codes are `UPPER_SNAKE_CASE`, semantic, and consistent across the entire API. Do not invent new codes for the same class of error in different endpoints.

---

## 3. PAGINATION, FILTERING & SORTING

### 3.1 Pagination Standard
Default to **cursor-based pagination** for all list endpoints. Use offset-based only when the consumer genuinely needs page-number navigation.

**Cursor-based (default):**
```
GET /users?limit=20&cursor=eyJpZCI6MTIzfQ==
Response: { "data": [...], "nextCursor": "eyJpZCI6MTQzfQ==", "hasMore": true }
```

**Offset-based (when justified):**
```
GET /users?limit=20&offset=40
Response: { "data": [...], "total": 150, "limit": 20, "offset": 40 }
```

### 3.2 Pagination Consistency
Pick ONE pagination strategy for the ENTIRE API. Do not use cursor-based for `/users` and offset-based for `/orders`.

### 3.3 Filtering
- Query parameters, flat structure: `GET /orders?status=shipped&createdAfter=2026-01-01`
- Multi-value filters: `GET /orders?status=shipped,delivered`
- Range filters: `GET /products?priceMin=10&priceMax=100`

### 3.4 Sorting
- Parameter: `sort`
- Format: `sort=field:direction` (e.g., `sort=createdAt:desc`)
- Multiple sorts: comma-separated: `sort=status:asc,createdAt:desc`
- Default sort must be documented

---

## 4. VERSIONING STRATEGY

### 4.1 Decision Tree
| Situation | Strategy |
|---|---|
| Internal API, same team controls both sides | No versioning. Break it and fix consumers. |
| Internal API, different teams | Header-based: `Accept-Version: v1` |
| Public API, breaking changes rare | URL path: `/v1/users` |
| Public API, rapid iteration | Header-based + deprecation window |

### 4.2 Versioning Rules
- **Never mix versioning strategies** in the same API
- **Breaking change = new version.** Non-breaking additions (new fields, new endpoints) stay on current version.
- **Deprecation header:** `Sunset: Sat, 31 Dec 2026 23:59:59 GMT` on deprecated responses
- **Document migration path** for every breaking change

---

## 5. IDEMPOTENCY

### 5.1 When Idempotency is Required
- All `POST` endpoints that create resources (to prevent duplicates on retry)
- All `PUT` endpoints (inherently idempotent, but document it)
- All payment/transaction endpoints (absolute requirement)

### 5.2 Implementation
- Accept `Idempotency-Key` header
- Return the SAME response (including status code) for repeated requests with the same key
- Store idempotency keys for at least 24 hours
- Return `409 Conflict` if a different request body is sent with the same key

---

## 6. REQUEST & RESPONSE MODELING

### 6.1 Request Body
- `POST` and `PUT`: body is required (unless the resource truly has no fields)
- `PATCH`: use JSON Merge Patch (RFC 7396) or JSON Patch (RFC 6902). Be consistent.
- `GET` and `DELETE`: no request body

### 6.2 Response Envelope
Use a consistent envelope for all list responses. For single-resource responses, the envelope is optional.

```json
// List response
{
  "data": [...],
  "nextCursor": "...",
  "hasMore": true
}

// Single resource response (envelope optional, direct resource OK)
{
  "id": "usr_123",
  "name": "Alice",
  "email": "alice@example.com"
}
```

### 6.3 Field Presence
- **Always return all fields**, even if null. Do not omit fields in some responses.
- **Null means "no value."** Missing field means "API version mismatch."
- **Empty array `[]` is NOT the same as `null`.** `[]` means "no items," `null` means "not applicable."

---

## 7. SECURITY & RATE LIMITING

### 7.1 Authentication
- Use `Authorization: Bearer <token>` header
- Never accept tokens in URL query parameters
- Document token format and expiry

### 7.2 Rate Limiting Headers
Every response must include:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 987
X-RateLimit-Reset: 1680000000
```

### 7.3 Input Validation
- Validate on the server, even if the client validates
- Return specific field errors, not "Invalid request"
- Sanitize inputs against injection before any other processing

---

## 8. DOCUMENTATION REQUIREMENTS

Every API must include:
- **Authentication** section: how to get a token, where to put it
- **Base URL**: one line at the top
- **Rate limits**: stated explicitly in the docs, not just in headers
- **Every endpoint** documented per sharp-tech-writing Section 2.2
- **Changelog**: when endpoints change, when versions deprecate

---

## 9. BANNED PATTERNS (AI Tells)

- **Mixing REST and RPC styles** in the same API (`GET /users` alongside `POST /cancelOrder`)
- **Inconsistent field naming**: `userId` in one response, `user_id` in another
- **200 OK with error body** — the HTTP status code MUST reflect the outcome
- **Generic error messages**: "Something went wrong" is never acceptable
- **Stack traces in production error responses**
- **GET endpoints that modify state** — this breaks every expectation of HTTP
- **Nested resources beyond 2 levels deep**: `/users/{id}/orders/{id}/items/{id}` is too deep. Flatten or use query params.
- **Pagination without `hasMore` or `total`** — the consumer cannot know when to stop fetching

---

## 10. PRE-FLIGHT CHECKLIST

- [ ] **API style declared**: REST / RPC-hybrid / event-driven, consumer type, traffic level?
- [ ] **Naming audit**: all resources plural, no verbs in URLs, one field naming convention throughout?
- [ ] **Error schema**: every endpoint returns the standard error response format?
- [ ] **Status codes**: semantically correct, no 200-for-errors?
- [ ] **Pagination**: one strategy for the whole API, `hasMore`/`nextCursor` in every list response?
- [ ] **Versioning**: strategy declared and applied consistently?
- [ ] **Idempotency**: key header on all POST endpoints that create resources?
- [ ] **Rate limiting**: headers on every response?
- [ ] **Field presence**: all fields returned, null vs. empty array semantics correct?
- [ ] **No banned patterns** from Section 9?
- [ ] **Auth**: token in header only, never in URL?

---

## 11. OUT OF SCOPE

This skill is NOT for:
- GraphQL schema design
- Database schema design
- gRPC / Protocol Buffer definitions
- WebSocket or SSE protocol design
- Message queue / event schema design
