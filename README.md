# [ProjectName]

Go API template for KnowFreedom projects.

## Stack
- Go 1.23
- Gin (HTTP framework)
- GORM + PostgreSQL
- golang-migrate (SQL migrations)
- JWT Bearer auth (golang-jwt/jwt/v5)
- Testcontainers-go (integration tests against real Postgres)
- Docker multi-stage build

## Getting Started
1. Clone this repo
2. Run `./scripts/scaffold.sh MyProjectName`
3. `cp .env.example .env` and fill in secrets
4. `docker compose up -d`
5. `go run ./cmd/MyProjectName`

See RULES.md for coding conventions.
