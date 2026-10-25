# Photo site starter kit

The shared files of a photo site, as described in [docs/photo-sites.md](../../docs/photo-sites.md): a static site generated from a repository's photos and captions, viewed locally with `scripts/site/serve.py` and published with `bin/deploy`.

```text
photo-site/
├── bin/deploy                    build, show changes, ask, upload
├── gitignore                     copy to .gitignore
├── photos/captions.csv           example captions; add photos in folders
├── scripts/
│   ├── check-no-fonts.sh
│   ├── sync-fonts.sh
│   └── site/
│       ├── build.py              the starting builder; extend per site
│       ├── build-deploy.sh
│       └── serve.py
└── site/assets/
    ├── css/                      base.css, gallery.css, typography.css
    └── js/                       viewer.js, theme.js, jump.js
```

## Start a new site

1. Copy the kit into the repository root, and copy `gitignore` to `.gitignore` (or merge it into an existing one).
2. Set the per-site values:
    - `bin/deploy`: the deploy constants (`SUBDIR`, `HOST`, `WEB_ROOT`, `SITE_URL`). The values here are placeholders.
    - `scripts/site/serve.py`: `DEFAULT_PORT`, different from the other sites you run locally.
    - `scripts/site/build.py`: `TITLE`, `KICKER`, `LEAD`, `PUBLIC_BASE` (`/<SUBDIR>/`), and optionally `PHOTO_ORDER` and `SECTION_SLUGS`.
3. Add photos in one folder per section under `photos/`, and a row for each in `photos/captions.csv` (a row ending in `/` captions the folder). Delete the example rows.
4. Copy the fonts in and view the site:

    ```sh
    scripts/sync-fonts.sh
    timeout 2h scripts/site/serve.py
    ```

5. Publish when ready: `bin/deploy --dry-run` shows what would be uploaded; `bin/deploy` asks before uploading. After the first deploy, run the live checks in [docs/photo-sites.md](../../docs/photo-sites.md#publishing).

## Keeping sites aligned

Every file here except `build.py` is shared. Sites keep them identical apart from the marked constants (`bin/deploy`'s deploy constants and `serve.py`'s `DEFAULT_PORT`). When one site improves a shared file, copy the change back here and to the other sites in the same pass.

`site/assets/css/typography.css` is [`assets/typefaces/nothing-sans.css`](../../assets/typefaces/nothing-sans.css) with its `url()` paths pointing at `../typefaces/`. When the canonical file changes, regenerate it the same way.

The fonts are not part of the kit and are never committed in a site repository; `scripts/sync-fonts.sh` copies them from the standards repository.
