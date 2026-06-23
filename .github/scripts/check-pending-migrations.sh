#!/bin/bash
# Fails CI if migration files are not paired correctly.
# Requires golang-migrate naming: NNNNNN_name.up.sql / NNNNNN_name.down.sql
set -e
echo "Checking migration file parity..."
UP_COUNT=$(find migrations/ -name "*.up.sql" 2>/dev/null | wc -l | tr -d ' ')
DOWN_COUNT=$(find migrations/ -name "*.down.sql" 2>/dev/null | wc -l | tr -d ' ')
if [ "$UP_COUNT" -ne "$DOWN_COUNT" ]; then
  echo "ERROR: Mismatched migration count (up=$UP_COUNT down=$DOWN_COUNT)."
  echo "Every *.up.sql must have a corresponding *.down.sql."
  exit 1
fi
echo "Migrations OK: $UP_COUNT up / $DOWN_COUNT down."
