#!/usr/bin/env bash
# -------------------------
# --    sync-fonts.sh    --
# -------------------------
# description: Copy the brand fonts the site uses from $FONTS_SRC into site/assets/typefaces/
#
#   scripts/sync-fonts.sh
#   FONTS_SRC=/path/to/typefaces scripts/sync-fonts.sh
#
# The fonts are licensed and never committed (see .gitignore). FONTS_SRC is
# the folder holding them, laid out as the CSS expects (sansserif/NothingSans-
# Book.otf and so on). It defaults to $HOME/Documents/Git/standards/assets/typefaces.
#
# Only the fonts site/assets/css/*.css references are copied, as real files (not
# symlinks). FONTS_SRC is only read. Exits nonzero, naming what's missing, if
# FONTS_SRC isn't a folder or any referenced font isn't in it.

set -euo pipefail
cd "$(dirname "$0")/.."

src="${FONTS_SRC:-$HOME/Documents/Git/standards/assets/typefaces}"
dest="site/assets/typefaces"

[ -d "$src" ] || { echo "FONTS_SRC is not a folder: $src" >&2; echo "Set FONTS_SRC to the folder holding the brand fonts." >&2; exit 1; }

# Paths under assets/typefaces/ named in url("../typefaces/..."), relative to
# site/assets/css/.
fonts=$(grep -ohE 'url\("\.\./typefaces/[^"]+"\)' site/assets/css/*.css | sed -E 's#^url\("\.\./typefaces/##; s#"\)$##' | sort -u)
[ -n "$fonts" ] || { echo "no fonts referenced in site/assets/css/*.css" >&2; exit 1; }

missing=0
for rel in $fonts; do
	[ -f "$src/$rel" ] || { echo "missing font: $src/$rel" >&2; missing=1; }
done
[ "$missing" = 0 ] || exit 1

for rel in $fonts; do
	mkdir -p "$dest/$(dirname "$rel")"
	rm -f "$dest/$rel"  # never write through an old symlink
	cp "$src/$rel" "$dest/$rel"
	echo "copied $rel"
done
