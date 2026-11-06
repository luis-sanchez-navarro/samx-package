#!/usr/bin/env bash
# Usage: bash scripts/check-adr.sh <path-to-adr-file>
set -euo pipefail

FILE="${1:?Usage: check-adr.sh <file>}"
ERRORS=0

if [ ! -f "$FILE" ]; then
  echo "ERROR: File not found: ${FILE}"
  exit 1
fi

check_section() {
  local section="$1"
  if ! grep -qi "^## ${section}" "$FILE"; then
    echo "ERROR: Missing section '## ${section}'"
    ERRORS=$((ERRORS + 1))
  fi
}

for section in "Status" "Context" "Decision" "Consequences"; do
  check_section "$section"
done

if ! grep -qiE "^(proposed|accepted|deprecated|superseded)" "$FILE"; then
  echo "ERROR: Status must be one of Proposed, Accepted, Deprecated, Superseded"
  ERRORS=$((ERRORS + 1))
fi

WORD_COUNT=$(wc -w < "$FILE")
if [ "$WORD_COUNT" -lt 100 ]; then
  echo "ERROR: ADR appears too short (${WORD_COUNT} words). Minimum is 100."
  ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -eq 0 ]; then
  echo "OK"
  exit 0
fi
exit 1
