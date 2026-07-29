# GitHub Pages Documentation Site Kit

Copy this kit into a consumer repository when adding a documentation-first GitHub Pages site. Read the Pages-related standards before installation.

The consumer repository owns its resulting `README.md`, `AGENTS.md`, `docs/`, and `.github/` files. Preserve existing documentation and adapt this kit to the project's real information architecture.

The starter uses Jekyll-compatible GitHub Pages layouts. Its underscore directories are platform conventions within `docs/`, not a general project structure pattern.

Use the default layout for ordinary documentation pages. It creates an on-page
table of contents from the page’s `##` and `###` headings. Add `layout:
reference` in a page’s front matter only when the documentation set needs the
extended three-column layout: project navigation on the left, content in the
center, and the generated on-page outline on the right.
