#!/usr/bin/env bash
# -----------------------------
# --    check-no-fonts.sh    --
# -----------------------------
# description: Fail if git tracks (or has staged) any font file
#
#   scripts/check-no-fonts.sh
#
# The brand fonts are licensed and must never be committed; scripts/sync-fonts.sh
# copies them in locally instead. Checks the index, so a staged font fails too.

set -euo pipefail
cd "$(dirname "$0")/.."

found=$(git ls-files | grep -iE '\.(woff2?|ttf|otf|eot)$|^site/assets/typefaces/' || true)
if [ -n "$found" ]; then
	echo "font files are tracked or staged in git; remove them with git rm --cached:" >&2
	echo "$found" >&2
	exit 1
fi
echo "no font files in git"
