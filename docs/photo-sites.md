# Photo Sites

A photo site is a small static website generated from a repository's photos and records, served locally while the work happens and published to a folder of a personal domain, such as `example.com/<project>/`. It lets someone outside the repository (a friend, a shop that will help with the work, a future reader) see the photos, captions, measurements, and notes without access to the repository.

This standard is the shape that three such sites converged on in October 2026. The starter kit in [`directory_structures/photo-site/`](../directory_structures/photo-site/) carries its shared files. Type is set by [docs/nothing-sans.md](nothing-sans.md).

## Principles

- **The repository is the source; the site is a view of it.** Pages are generated from the photos, captions, and Markdown records on every build. Generated pages are not edited by hand.
- **Originals never leave the machine.** Photos in the repository keep their full metadata, including GPS. Only resized copies, stripped of everything but their color profile, are published, and the build fails if anything else survives.
- **Nothing is published by accident.** Publishing shows exactly what would change and asks first. It never deletes anything on the server.
- **Shared files stay identical.** A file the sites share is the same file in every site, except for clearly marked constants. Improve it in one site, then copy it to the others.

## Repository layout

```text
project/
├── bin/
│   └── deploy                  build, show changes, ask, upload (shared)
├── photos/
│   ├── captions.csv            title, description, and kind per photo; a row
│   │                           ending in "/" captions a folder (one section)
│   └── <section>/              one folder per page section
├── scripts/
│   ├── check-no-fonts.sh       fail if git tracks a font file (shared)
│   ├── sync-fonts.sh           copy the referenced fonts in (shared)
│   └── site/
│       ├── build.py            generate the pages, routes, and rules (per site)
│       ├── build-deploy.sh     build the public copy and check it (shared)
│       └── serve.py            local server (shared)
├── site/
│   ├── assets/
│   │   ├── css/                base.css (shared), layout, typography.css
│   │   ├── js/                 viewer.js, theme.js, jump.js (shared)
│   │   └── typefaces/          copied in by sync-fonts.sh; git-ignored
│   └── ...                     generated pages, thumbnails, routes.json,
│                               htaccess; all git-ignored
└── work/
    └── site-deploy/            the public copy; git-ignored
```

CSS and JS live under `site/assets/`, beside the typefaces. A site may add its own files (an editing page, a video viewer, a database of records), but the shared files and this layout stay as they are.

## Shared files and per-site settings

| File | Shared | Per-site setting |
| --- | --- | --- |
| `bin/deploy` | yes | the deploy constants at the top: `SUBDIR`, and the host, web root, and site URL |
| `scripts/site/serve.py` | yes | `DEFAULT_PORT`: give each site its own, so several can run at once |
| `scripts/site/build-deploy.sh` | yes, unless the site has special publishing needs | none |
| `scripts/sync-fonts.sh`, `scripts/check-no-fonts.sh` | yes | none |
| `site/assets/js/viewer.js`, `theme.js`, `jump.js` | yes | none |
| `site/assets/css/base.css` | yes | none |
| `scripts/site/build.py` | no | everything: it knows the site's records and sections; set `PUBLIC_BASE` to the published folder |

A site with special publishing needs may keep its own `build-deploy.sh` (for example, to leave out an editing page or copy videos), as long as `bin/deploy` can run it unchanged and it makes the same checks.

## URLs

- **Clean URLs.** A record is addressed by its repository path without the extension: `notes/runner-plan.md` is `/notes/runner-plan`. README files become `readme`.
- **Sections have short slugs of their own,** not folder paths, and the slug must not repeat the site's name: `/<project>/drawer`, not `/<project>/<project>-drawer`. Opening a section URL loads the home page at that section. Check-in sites can use dates (`/2026-10-21`).
- **Old URLs keep working.** When a URL changes, the old one redirects permanently (301), and an old `#section` link is rewritten to the clean URL in the browser.
- **One route list, two forms.** `build.py` writes the routes once, as `site/routes.json` for the local server and as `site/htaccess` (Apache rewrite rules) for the live server, so local and live URLs cannot drift apart.
- **Folders that are also sections.** Apache adds a trailing slash to a folder path before rewrite rules run. If a section slug can also be a folder, turn that off for the section paths only, inside `<If "%{REQUEST_URI} =~ m#^/<base>/(sections)/?$#">`, and redirect a typed trailing slash to the bare path, because the page's relative links only work without it. Never turn it off for the whole site: the site's own folder (`/<project>`) still needs its slash.
- **Relative links.** Pages link relatively, at the right depth, so the same pages work at a local server's root and under the published folder.

## Caching

- CSS and JS links carry `?v=<content hash>`, so a change gets a new URL.
- Pages are served `Cache-Control: no-cache`, so a deploy shows up on the next load. The rule sits inside `<IfModule mod_headers.c>`, so the server needs `mod_headers` enabled. Without it the rule is skipped silently; check a page's response headers after the first deploy.

## Images

- Published photos are resized to 2400px on the long edge at quality 85, with all metadata removed except the ICC color profile: `magick ... +profile '!icc,*'`. Keep the profile. iPhone photos are wide-color (Display P3) and look flatter in browsers without it.
- Grid thumbnails, when a site uses them, get the same treatment.
- `build-deploy.sh` checks every published image with `exiftool` and fails if any group other than the file basics and the ICC profile remains.
- Caption and manifest files are never published.

## Fonts

- Sites are set in Nothing Sans, following [docs/nothing-sans.md](nothing-sans.md). `site/assets/css/typography.css` holds the face declarations and type rules, with `url("../typefaces/...")` paths relative to `assets/css/`.
- Font files are not committed in site repositories. `scripts/sync-fonts.sh` copies the faces the CSS references from the standards repository's `assets/typefaces/` (or `$FONTS_SRC`), and `scripts/check-no-fonts.sh` fails if git tracks one. `.gitignore` excludes `site/assets/typefaces/` and the font file types.
- The deploy copies only the fonts the CSS and pages reference, and fails if one is missing, unless `--allow-fallback` is passed.

## Local server

`scripts/site/serve.py` is for local viewing only:

- It binds `127.0.0.1` and accepts only requests whose `Host` header names it (protection against DNS rebinding).
- It serves `site/` and `photos/` and nothing else: no other repository folder, no dotfiles, no `..`, no symlink that leads outside, no folder listings, GET and HEAD only.
- It rebuilds the pages on each page load and reloads `build.py` too, so edits show up without a restart.
- It follows `routes.json`, including the trailing-slash redirect, so local URLs behave like the live ones.
- Start it with a time limit when leaving it running: `timeout 2h scripts/site/serve.py`.

## Publishing

`bin/deploy` runs `scripts/site/build-deploy.sh`, then uses `rsync` to compare by checksum (`-c`, ignoring directory times with `-O`), lists only new or changed files, asks, and uploads. Every build rewrites the files, so comparing by modification time would list every file every time.

| Command | Effect |
| --- | --- |
| `bin/deploy` | build, list changes, ask, upload |
| `bin/deploy --dry-run` | build and list changes; upload nothing |
| `bin/deploy --yes` | build and upload without asking |
| `bin/deploy --allow-fallback` | build even if a font is missing |

`build-deploy.sh` fails the build if any of these is true:

- a page lacks `<meta name="robots" content="noindex">`
- `.htaccess` lacks `Options -Indexes`
- a referenced font is missing
- a CSV or a stray dotfile is in the copy
- an image carries metadata beyond its color profile

Nothing is deleted on the server. A file removed locally stays there until removed by hand.

After the first deploy, and after any URL change, check the live site:

```sh
curl -sI https://example.com/<project>/ | grep -i cache-control      # no-cache
curl -s -o /dev/null -w '%{http_code}\n' https://example.com/<project>/<section>     # 200
curl -s -o /dev/null -w '%{http_code}\n' https://example.com/<project>/photos/       # 403
```

## Page design

- **Type** follows [docs/nothing-sans.md](nothing-sans.md): Light reading copy, Book small text, a huge Bold headline, letter-spacing 0, the link style with the `go` arrow, list items in reading copy set like paragraphs.
- **Tables:** Book at the small size; a 3px rule under the header row, 1px between rows, none after the last row, the same rules as the Pages kit; bottom padding larger by `--nothing-optical-bottom` (0.192em).
- **Top bar:** the site's name at the left, a plain brand mark linking home (no underline until hover), and the Light / Dark / Auto switch at the right (`theme.js`).
- **Photo viewer** (`viewer.js`): full screen, arrow keys and swipe, a dark backdrop taken from each photo, a URL per photo (`#photo-<section>-<name>`).
- **Section jump** (`jump.js`): on pages with a bar of section links, a click cuts to 50px short of the section and slides into place over 700ms with an ease-out-expo curve, with no fade. Back and Forward glide between sections. With reduced motion preferred, it jumps. A page with a single section shows no bar but still handles section URLs and old links. On the local server, `?lead=`, `?fade=`, and `?duration=` override the settings for comparison.
- **Colors** come from `base.css`: one palette, with a night version that follows the system appearance.

## Deployment details

Each site's `bin/deploy` names the SSH host, the web root, and the site's folder. Those values are personal infrastructure and are not part of this public standard. The starter kit uses placeholders.
