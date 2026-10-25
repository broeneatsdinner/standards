#!/usr/bin/env bash
# ---------------------------
# --    build-deploy.sh    --
# ---------------------------
# description: Build the public copy of the project site in work/site-deploy/
#
#   scripts/site/build-deploy.sh [--allow-fallback]
#
# Shared by the project sites: the same file in each repository. Steps:
#
# 1. scripts/check-no-fonts.sh: stop if git tracks any font file.
# 2. scripts/sync-fonts.sh: copy the brand fonts in from $FONTS_SRC.
# 3. scripts/site/build.py: regenerate the pages (and thumbnails, if the
#    site uses them), site/routes.json, and site/htaccess.
# 4. Write work/site-deploy/ (git-ignored), replacing any earlier copy:
#      index.html and        every page listed in site/routes.json, at its
#      other pages           path (already noindex)
#      .htaccess             site/htaccess: clean URLs, old-link redirects,
#                            no-cache pages, Options -Indexes
#      assets/css, js        as in the source
#      assets/typefaces      only the fonts the CSS and pages reference
#      thumbs/               the grid thumbnails the pages show, if any,
#                            metadata stripped again
#      photos/               only the photos the pages show or open, 2400px
#                            on the long edge, quality 85, all metadata
#                            removed but the color profile; caption and
#                            manifest files are never copied
# 5. Check that every page is noindex, every referenced font is present, no
#    CSV or stray dotfile slipped in, and no image carries metadata beyond
#    its color profile (the originals hold GPS coordinates of where they were
#    taken). The ICC color profile is kept on purpose: iPhone photos are
#    wide-color (Display P3) and look flat in browsers without it.
#
# A missing font fails the build. --allow-fallback builds anyway, with the
# pages falling back to the system font; it says so loudly.

set -euo pipefail
cd "$(dirname "$0")/../.."

allow_fallback=0
for arg in "$@"; do
	case "$arg" in
		--allow-fallback) allow_fallback=1 ;;
		*) echo "usage: scripts/site/build-deploy.sh [--allow-fallback]" >&2; exit 2 ;;
	esac
done

src="site"
out="work/site-deploy"

scripts/check-no-fonts.sh
if ! scripts/sync-fonts.sh; then
	if [ "$allow_fallback" = 1 ]; then
		echo "WARNING: font sync failed; continuing because of --allow-fallback" >&2
	else
		echo "Font sync failed (above). Fix FONTS_SRC, or rerun with --allow-fallback to publish with the system font." >&2
		exit 1
	fi
fi
scripts/site/build.py

rm -rf "$out"
mkdir -p "$out"
cp "$src/index.html" "$out/"
mkdir -p "$out/assets"
cp -R "$src/assets/css" "$src/assets/js" "$out/assets/"
# Every page build.py listed in routes.json, at its path (index.html,
# notes/x.html).
python3 -I -c 'import json, sys; [print(p) for p in json.load(open(sys.argv[1]))["pages"].values()]' "$src/routes.json" |
	while IFS= read -r rel; do
		mkdir -p "$out/$(dirname "$rel")"
		cp "$src/$rel" "$out/$rel"
	done
# Never list folder contents, e.g. <site>/photos/.
cp "$src/htaccess" "$out/.htaccess"
grep -q '^Options -Indexes' "$out/.htaccess" || { echo ".htaccess lost Options -Indexes" >&2; exit 1; }

pages=$(find "$out" -name '*.html')

# Every page must carry noindex.
for p in $pages; do
	grep -q '<meta name="robots" content="noindex">' "$p" || { echo "page without noindex: $p" >&2; exit 1; }
done

# Every font the stylesheets and the pages name, as paths from the site root.
fonts=$( {
	grep -ohE 'url\("\.\./typefaces/[^"]+"\)' "$src"/assets/css/*.css | sed -E 's#^url\("\.\./#assets/#; s#"\)$##'
	grep -ohE '<link rel="preload" href="[^"]+" as="font"' $pages | sed -E 's#^<link rel="preload" href="(\.\./)*##; s#" as="font"$##'
} | sort -u )

for rel in $fonts; do
	[ -f "$src/$rel" ] || continue  # reported below
	mkdir -p "$out/$(dirname "$rel")"
	cp "$src/$rel" "$out/$rel"
done

missing=""
for rel in $fonts; do
	[ -f "$out/$rel" ] || missing="$missing  $rel"$'\n'
done
if [ -n "$missing" ]; then
	echo "Fonts missing from the deploy copy:" >&2
	printf '%s' "$missing" >&2
	if [ "$allow_fallback" = 1 ]; then
		echo "WARNING: --allow-fallback: the public pages will use the system font for these." >&2
	else
		echo "Not building a deploy copy without them. Run scripts/sync-fonts.sh (check FONTS_SRC), or pass --allow-fallback." >&2
		rm -rf "$out"
		exit 1
	fi
fi

# Thumbnails the pages show, if the site uses them, re-stripped (all but the
# color profile).
# (grep finds nothing on a site without thumbnails; || true keeps pipefail
# from ending the script there.)
{ grep -ohE 'src="(\.\./)*thumbs/[^"]+"' $pages || true; } | sed -E 's#^src="(\.\./)*##; s#"$##' | sort -u | while read -r rel; do
	[ -f "$src/$rel" ] || { echo "missing thumbnail: $rel" >&2; exit 1; }
	mkdir -p "$out/thumbs"
	magick "$src/$rel" +profile '!icc,*' "$out/$rel"
done

# Photos the pages show (src) or the viewer opens (data-full). Paths are
# URL-encoded in the pages (file names may have spaces), so decode them first.
{ grep -ohE '(src|data-full)="(\.\./)*photos/[^"]+"' $pages || true; } | sed -E 's#^(src|data-full)="(\.\./)*##; s#"$##' | sort -u |
	python3 -I -c 'import sys, urllib.parse; [print(urllib.parse.unquote(l.strip())) for l in sys.stdin]' |
	while IFS= read -r rel; do
		[ -f "$rel" ] || { echo "missing photo: $rel" >&2; exit 1; }
		mkdir -p "$out/$(dirname "$rel")"
		magick "$rel" -auto-orient -resize '2400x2400>' -quality 85 +profile '!icc,*' "$out/$rel"
	done

stray=$(find "$out" \( -iname '*.csv' -o -name '.*' \) -not -path "$out" -not -path "$out/.htaccess")
[ -z "$stray" ] || { echo "unexpected files in the deploy copy:" >&2; echo "$stray" >&2; exit 1; }

images=$(for d in photos thumbs; do if [ -d "$out/$d" ]; then echo "$out/$d"; fi; done)
leaks=$(exiftool -q -G1 -s -r -ext jpg -ext jpeg -ext png -ext webp $images | grep -vE '^\[(ExifTool|File|System|Composite|JFIF|ICC_Profile|ICC-[a-z]+)\]' | grep -v '^========' || true)
[ -z "$leaks" ] || { echo "metadata found in deploy images:" >&2; echo "$leaks" >&2; exit 1; }

count() { [ -d "$out/$1" ] && find "$out/$1" -type f | wc -l | tr -d ' ' || echo 0; }
echo "pages: $(echo "$pages" | grep -c .)  fonts: $(echo "$fonts" | grep -c .)  thumbs: $(count thumbs)  photos: $(count photos)"
du -sh "$out"
