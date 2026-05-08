#!/usr/bin/env bash
# -------------------------
# --    sanitize-scan    --
# -------------------------

# Lightweight exposure scan for a multi-node infrastructure repository.
#
# This file is meant to be run directly with Bash:
#
#	bash tools/audit/sanitize_scan.sh

set -euo pipefail

patterns=(
	"PRIVATE KEY"
	"BEGIN CERTIFICATE"
	"api[_-]key"
	"token"
	"password"
	"/Users/"
	".env"
)

status=0

for pattern in "${patterns[@]}"; do
	if rg -n --hidden --glob '!.git/' --glob '!private/' "$pattern" .; then
		printf '%s\n' "Review required for pattern: $pattern"
		status=1
	fi
done

if [[ "$status" -eq 0 ]]; then
	printf '%s\n' "No obvious exposure patterns found."
fi

exit "$status"
