#!/usr/bin/env bash
# -----------------------------------
# --    public_release_check.sh    --
# -----------------------------------

# Public-release checklist for a multi-node infrastructure repository.
#
# This file is meant to be run directly with Bash:
#
#	bash tools/audit/public_release_check.sh

set -euo pipefail

required_paths=(
	"README.md"
	"docs/architecture.md"
	"docs/threat-model.md"
	"docs/sanitization.md"
	"nodes"
	"shared"
	"tools/audit/sanitize_scan.sh"
)

status=0

for path in "${required_paths[@]}"; do
	if [[ ! -e "$path" ]]; then
		printf '%s\n' "Missing required path: $path"
		status=1
	fi
done

if [[ -d private ]]; then
	printf '%s\n' "Review required: private/ exists locally and must not be exported."
	status=1
fi

bash tools/audit/sanitize_scan.sh || status=1

if [[ "$status" -eq 0 ]]; then
	printf '%s\n' "Public release checks passed."
fi

exit "$status"
