# Add GitHub Pages Documentation

Use this workflow when the operator asks to add Pages, generate a documentation
site, or apply the documentation system from the standards repository.

## Outcome

Create one documentation system, not a README, wiki, and Pages site that drift
apart:

```text
README.md
    -> project-specific GitHub front door and early link to the manual
docs/
    -> canonical long-form documentation and Pages source
GitHub Pages
    -> rendering of approved docs/ material
```

Apply the canonical [repository documentation system](../docs/github-pages-guidelines.md#repository-documentation-system): `README.md` is the front door, `docs/` is the canonical manual and Pages source, and `AGENTS.md` records project operating instructions.

Use `pages/github-pages-docs-site/` as the presentation kit. Adapt it to the
consumer repository; never copy it blindly over intentional documentation.

## Authority boundaries

Adding documentation files and running a local preview are implementation work
when the operator asks to add Pages. Deployment, GitHub Pages activation,
publication, sanitization claims, pushes, and opening pull requests require
separate explicit approval.

For private repositories, do not add a deployment workflow unless the operator
explicitly asks. Treat private artifacts, topology, identity material, scans,
and lineage as non-public until a separate publication review says otherwise.

## Discovery pass

1. Confirm the target repository with `pwd` and `git status`.
2. Read any repository `AGENTS.md` files.
3. Read `prompts/universal.md`, then load only the relevant standards:
   - `docs/readme-guidelines.md`
   - `docs/github-pages-guidelines.md`
   - `docs/wiki-policy.md`
   - `docs/documentation-templates.md`
   - `docs/documentation-writing-style.md`
   - `docs/ai-agent-instructions.md`
4. Inspect the root README, existing `docs/`, repository structure, and any
   existing Pages configuration or workflow.
5. Identify the existing narrative, technical manuals, and material that must
   not be exposed publicly.

Do not treat discovery as permission to deploy, publish, overwrite, or delete.

## README-to-Pages migration

When the existing root README already contains substantial project narrative or
technical detail:

1. Create an adjacent exact snapshot: `README.pre-pages.md`.
2. Promote the enduring narrative into `docs/index.md`, preserving its voice
   and concrete technical detail. Split it into additional canonical docs pages
   only when that improves the reader's path.
3. Rewrite the active root `README.md` as a concise front door. It must retain
   a compact, unmistakably project-specific opening; do not replace it with a
   generic directory index.
4. Put a prominent **Read the manual** link in the opening screenful, after the
   project framing and before lower-priority detail. Link to `docs/index.md`
   until there is an approved stable Pages URL.
5. Keep `README.pre-pages.md` as a migration record only. It is not a second
   maintained manual.

If the README is already a good front door, preserve it and add the manual link
without needless migration.

## Pages installation

1. Keep existing project docs in `docs/`; do not create a parallel content
   tree.
2. Add the Jekyll-compatible support files from the kit inside `docs/`:
   `_config.yml`, `_layouts/`, `_includes/`, `_data/navigation.yml`, shared CSS,
   and the generated on-page TOC script.
3. Add only the front matter required to render existing Markdown pages. Keep
   their substantive prose intact.
4. Create or adapt `docs/index.md` as the Pages home. It should be an authored
   orientation page or the migrated project narrative, not generic template
   copy.
5. Build the persistent left navigation from the repository's real manual
   structure. The right navigation must be generated from the current page's
   `##` and `###` headings.
6. Add or update root `AGENTS.md` so future agents know that README is the
   front door, `docs/` is canonical, navigation lives in one data file, and
   Pages is presentation rather than a second source.

Use the extended layout only when the documentation set genuinely needs both a
persistent project map and a current-page outline. Keep Markdown tables as one
shared, readable table system; do not introduce a separate HTML-only table
language without a documented need.

## Writing requirements

Choose the appropriate orientation, guide, or reference mode. Preserve the
project's actual voice: concrete entry points, technical exactness, visible
evidence boundaries, and clear operating responsibility. Do not flatten an
interesting README into generic product or technical-writer language merely to
make it shorter.

## Validation and checkpoint

1. Run `git diff --check`.
2. Validate navigation data and JavaScript syntax.
3. Build locally with Jekyll into a temporary output directory.
4. Start a local-only preview on `127.0.0.1` when the operator wants to review
   the rendering.
5. Review the generated Pages home, an ordinary page, and a dense reference or
   field-manual page.
6. Commit each coherent change set locally after validation. Do not push unless
   separately instructed.

## Publication later

Before any publication decision, run the applicable OPSEC and publication
review. Confirm the approved public documentation set, sanitize it deliberately,
then add the Actions-based Pages deployment workflow only with explicit
authorization.
