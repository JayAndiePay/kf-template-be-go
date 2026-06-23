# Build stage
FROM golang:1.23-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/bin/[ProjectName] ./cmd/[ProjectName]

# Runtime stage — non-root user
FROM alpine:3.20 AS runtime
WORKDIR /app

RUN addgroup -S appgroup && adduser -S -G appgroup -u 1001 appuser

COPY --from=build --chown=appuser:appgroup /app/bin/[ProjectName] .
USER appuser

EXPOSE 8080
ENTRYPOINT ["./[ProjectName]"]
