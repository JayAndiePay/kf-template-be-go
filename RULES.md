# Project Rules & Conventions — [ProjectName]

> **Read this first.** Source of truth for how code is written here.
> Any human or AI must follow this. Change the rule here before changing code.

---

## 1. Language & Typing

### 1.1 Go with strict error handling
Never discard errors with `_`. Every error is either returned or explicitly logged with context.

### 1.2 Wrap errors with context
Use `fmt.Errorf("operation: %w", err)` at every callsite. Callers can inspect with `errors.Is` / `errors.As`.

### 1.3 No magic strings
All string constants (config keys, claim names, context keys) are defined in `internal/common/constants/constants.go`.

### 1.4 No panic outside main
Never use `panic` in library or feature code. Return typed errors. `log.Fatalf` is allowed only in `main()`.

### 1.5 No plaintext secrets
No secrets in `.env.example`, source code, or commit history. `.env` is git-ignored. Use environment variables.

---

## 2. Code Organization

### 2.1 Vertical slice architecture
Code is organized by **feature**, not by layer. Each feature folder contains its own handler, service, and types.

```
cmd/
  [ProjectName]/
    main.go
internal/
  features/
    [feature]/
      handler.go     # HTTP handler — registers routes, parses input, calls service
      service.go     # business logic (omit for trivial features)
      types.go       # request/response types for this feature
  common/
    config/          # env-based config struct
    middleware/      # HTTP middleware (logging, auth, recovery)
    constants/       # no-magic-strings constants
  infrastructure/
    database/        # GORM connection setup
migrations/
  000001_init.up.sql
  000001_init.down.sql
```

### 2.2 File naming
| What | Pattern |
|---|---|
| HTTP handler | `handler.go` |
| Business logic | `service.go` |
| Request/response types | `types.go` |
| Migration | `NNNNNN_name.up.sql` / `NNNNNN_name.down.sql` |
| Unit test | `handler_test.go` / `service_test.go` |
| Integration test | `integration_test.go` |

### 2.3 Interfaces where consumed, not where implemented
Define interfaces in the package that uses them, not the package that implements them.

### 2.4 Non-root Docker user
All Dockerfiles create a non-root `appuser` at uid 1001 and run as that user.

---

## 3. Data Handling

### 3.1 Never log sensitive data
No tokens, passwords, PII, query parameters, or request bodies in log output.
Log only: method, path, status code, latency.

### 3.2 GORM query logging off
`gorm.Config{Logger: logger.Silent}` — queries can contain PII. Use DB metrics instead.

### 3.3 Database migrations
Migrations live in `migrations/` using golang-migrate SQL format (`NNNNNN_name.up.sql` / `.down.sql`).
Never apply manually — run via the deploy pipeline. CI checks up/down parity.

---

## 4. Tech Stack

| Concern | Choice |
|---|---|
| Framework | Gin |
| ORM | GORM |
| Database | PostgreSQL |
| Migrations | golang-migrate (SQL files) |
| Auth | golang-jwt/jwt/v5 |
| Docs | swaggo/swag |
| Tests | testing + testcontainers-go |
| Config | godotenv + env vars |
| Containerization | Docker (multi-stage, non-root user) |
| Secrets | Environment variables only |

---

## 5. Testing

- Unit tests co-located per feature (`handler_test.go`, `service_test.go`).
- Integration tests use `testcontainers-go` — real Postgres, no mocking the DB layer.
- Table-driven tests preferred (`t.Run` subtests).
- CI runs `go test -race -count=1 ./...` — race detector is always on.

---

## 6. Definition of Done

1. `gofmt -l .` returns empty (zero unformatted files).
2. `go build ./...` passes.
3. `go vet ./...` passes with 0 warnings.
4. `go test -race ./...` passes (unit + integration) — **hard gate before Docker build**.
5. No magic strings — use constants.
6. `docker build` succeeds.
7. No sensitive data in logs or config files.
8. Every new migration has a matching `.down.sql`.
