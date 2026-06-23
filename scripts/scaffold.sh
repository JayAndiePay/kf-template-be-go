#!/bin/bash
set -e
if [ -z "$1" ]; then
  echo "Usage: ./scripts/scaffold.sh ProjectName"
  exit 1
fi
PROJECT="$1"
PROJECT_KEBAB=$(echo "$PROJECT" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
PROJECT_SNAKE=$(echo "$PROJECT" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr '-' '_')
echo "Scaffolding $PROJECT..."

# Replace placeholders in all relevant file types
find . -type f \( \
  -name "*.go" -o -name "*.mod" -o -name "*.sql" \
  -o -name "docker-compose.yml" -o -name "Dockerfile" \
  -o -name "*.sh" -o -name "*.md" -o -name ".env*" \
  -o -name "*.yml" -o -name "*.yaml" \
\) ! -path "./.git/*" \
  -exec sed -i '' \
    "s/\[ProjectName\]/$PROJECT/g; \
     s/\[project-name\]/$PROJECT_KEBAB/g; \
     s/\[project_name\]/$PROJECT_SNAKE/g" {} +

# Rename the cmd entry point directory
if [ -d "cmd/[ProjectName]" ]; then
  mv "cmd/[ProjectName]" "cmd/$PROJECT"
fi

echo "Done. Project is now: $PROJECT"
echo ""
echo "Next steps:"
echo "  cp .env.example .env       # fill in your secrets"
echo "  docker compose up -d       # start Postgres"
echo "  go mod tidy                # download dependencies"
echo "  go run ./cmd/$PROJECT      # run the API"
