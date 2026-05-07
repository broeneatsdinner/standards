# Media Asset Workflow

This document defines a reusable intake and curation workflow for media assets in Field Manual repositories and documentation-first public repositories.

Media assets should not move directly from a camera, phone, screenshot folder, scanner, download directory, or private workspace into public documentation.

Raw media needs a quarantine path.

Public media needs a curation path.

The goal is to preserve useful visual material while reducing accidental exposure of private information, metadata, locations, devices, routines, account details, and background context.

## Operating rule

Commit only curated public-safe copies.

Do not commit raw intake by default.

Do not commit private intake by default.

Do not commit contact sheets generated from private intake unless they have been intentionally sanitized and reviewed as public artifacts.

Treat visual assets as documentation with an exposure surface.

## Recommended folders

Use folders that make the asset state visible from the path.

Recommended structure:

```text
assets/inbox/
assets/private-inbox/
assets/contact-sheets/
assets/reference/
assets/gear/
assets/workflow/
assets/finished-drinks/
```

`assets/inbox/` is for temporary raw intake when collecting assets.

`assets/private-inbox/` is for quarantined raw intake that should be ignored and kept out of commits.

`assets/contact-sheets/` is for generated review sheets. These should normally stay untracked unless the sheet itself has been sanitized and is intentionally part of the public documentation.

`assets/reference/` is for curated public-safe reference images.

`assets/gear/` is for curated public-safe equipment, component, and object images.

`assets/workflow/` is for curated public-safe process images.

`assets/finished-drinks/` is an example domain-specific folder for a Field Manual that documents finished outputs.

Adapt the public folders to the system being documented, but keep the distinction between raw intake, private review material, and curated public assets.

## Ignore rules

Raw and private intake folders should not be committed.

At minimum, add ignore rules in the repository that match the chosen intake paths.

Example:

```gitignore
assets/inbox/
assets/private-inbox/
assets/contact-sheets/
```

This is a default posture, not a substitute for review.

If a contact sheet is intentionally published, move or copy a sanitized version into an appropriate public asset folder and give it a public-safe name.

## Workflow

### 1. Raw intake

Collect source images, screenshots, scans, exports, and downloads into an intake area.

Do not rename or edit the only copy during intake.

The intake step is allowed to be messy because it is not public.

Example:

```text
assets/inbox/IMG_4921.jpeg
assets/inbox/Screenshot 2026-05-07 at 9.14.03 AM.png
assets/inbox/receipt-counter-setup.jpg
```

This folder is a staging point, not a publication folder.

### 2. Private ignored quarantine

Move raw intake into a private ignored quarantine before review.

Example:

```text
assets/private-inbox/IMG_4921.jpeg
assets/private-inbox/Screenshot 2026-05-07 at 9.14.03 AM.png
assets/private-inbox/receipt-counter-setup.jpg
```

The quarantine folder keeps raw material available for local review while making the publication boundary explicit.

Anything in this folder should be assumed private until proven otherwise.

### 3. Contact sheet review

Generate a contact sheet from the private intake folder when there are enough images that individual review becomes slow.

The contact sheet is a review artifact.

It helps compare similar images, select public candidates, detect obvious exposure issues, and avoid accidentally publishing the wrong source file.

For large image sets, use numbered contact sheets.

Each thumbnail should show:

- a stable integer identifier
- the original source filename

Generate a local index that maps each number to its source filename.

Example:

```text
1 -> IMG_4921.jpeg
2 -> Screenshot 2026-05-07 at 9.14.03 AM.png
3 -> receipt-counter-setup.jpg
```

Use the integer identifiers during human and AI classification discussion.

This reduces review friction, avoids copy/paste errors with UUID or camera-default filenames, improves audit traceability, and makes human/AI collaboration clearer.

Contact sheets generated from private intake should normally stay ignored.

They may contain thumbnails of private, discarded, or not-yet-redacted images.

The number-to-filename index is also a review artifact.

Keep contact sheets and number indexes private and ignored unless they have been intentionally sanitized and reviewed for publication.

Do not publish a contact sheet just because it is convenient.

### 4. Classification

Classify each asset before it is sanitized or copied into public folders.

Use these categories:

- public candidate
- reference-only
- discard
- needs crop/redaction

`public candidate` means the asset appears useful and likely safe after metadata stripping and final review.

`reference-only` means the asset is useful for the author or operator but should not become public documentation.

`discard` means the asset is not useful, redundant, low quality, or too risky to retain.

`needs crop/redaction` means the asset may become public after visible sensitive details are removed.

Do not let the classification label substitute for inspection.

An image can move from `public candidate` to `discard` during final audit if a new exposure issue appears.

### 5. Metadata stripping and sanitization

Strip metadata before committing public images.

Inspect for:

- EXIF
- GPS data
- device make and model
- camera or app names
- timestamps
- author or creator fields
- editing software
- embedded thumbnails or previews

Also inspect the visible content.

Screenshots and photos should be reviewed for:

- browser tabs
- terminal paths
- account names
- map pins
- reflections
- receipts
- QR codes
- barcodes
- background details
- labels
- documents
- usernames
- hostnames
- private URLs

Cropping is not enough if the original file with metadata or hidden content is still committed.

Redaction should create a new sanitized public copy.

The raw source should remain private or be discarded.

### 6. Curated public copy

Copy only sanitized, reviewed assets into public asset folders.

Use the destination folder to describe the asset's role in the documentation.

Examples:

```text
assets/gear/hand-grinder-side-profile.jpg
assets/workflow/beans-weighed-before-grinding.jpg
assets/reference/counter-layout-reference.jpg
assets/finished-drinks/cortado-final-cup.jpg
```

Public assets should have stable, descriptive names.

Naming guidance:

- use lowercase
- use hyphen-separated words
- use descriptive names
- use `.jpg`, not `.jpeg`
- make the filename extension match the actual file type
- avoid UUID names
- avoid camera-default names
- avoid screenshot-default names

Good:

```text
assets/workflow/portafilter-dose-before-tamping.jpg
assets/gear/fellow-kettle-temperature-display.jpg
```

Bad:

```text
assets/workflow/IMG_4921.jpeg
assets/gear/0f65a4ec-41a7-4b0f-9212-2b6ccf79a779.jpg
assets/reference/Screenshot 2026-05-07 at 9.14.03 AM.png
```

The public filename should help a reader understand why the asset exists.

It should not preserve private collection history.

The public filename should also describe the file truthfully.

A `.jpg` filename that contains PNG data is a publication-quality defect even when the image is otherwise safe to publish.

That mismatch is not primarily an OPSEC finding. It is a filename normalization, repository-quality, and tooling-consistency problem.

Extension/content mismatches can break image tooling, static-site builds, repository previews, MIME detection, search indexing, cache behavior, automation, and downstream workflows that route files by extension.

Metadata remediation and filename/type normalization are separate phases:

- metadata remediation strips or reduces embedded private data in approved public media copies
- filename/type normalization makes public filenames, extensions, references, and rendered outputs consistent with the actual asset type

Do not silently rename media files during metadata remediation.

Normalize filenames only through an explicit approved remediation step.

When normalization is approved, update every internal reference, import, link, manifest entry, generated index, and documentation path that points at the renamed asset.

After normalization, verify that repository previews, documentation rendering, static builds, and relevant automation still resolve and display the asset correctly.

### 7. Final publication audit

Run a final publication audit before making the repository public or before publishing a major documentation update.

Review:

- tracked media files
- staged media files
- ignored intake paths
- generated contact sheets
- number-to-filename indexes
- filenames
- extension/content consistency
- visible image content
- media metadata
- git history when relevant

The audit should confirm that only curated public-safe copies are committed.

If raw assets were ever committed, review history for exposed metadata or private content.

Removing a file from the current tree may not remove it from repository history.

Use `prompts/publication-opsec-02-audit.md` as the audit frame when preparing public release.

## OPSEC notes

Media assets can reveal more than their subject.

A photo of gear can reveal a room, a routine, a receipt, a reflection, a serial number, a child-related object, a map, or a home layout.

A screenshot can reveal tabs, paths, account names, editor state, terminal prompts, private URLs, map pins, or local project names.

A filename can reveal dates, errands, locations, people, camera behavior, or private mental categories.

Metadata can reveal GPS coordinates, device details, timestamps, editing software, and document history.

The publication question is not only:

```text
Is this image useful?
```

The better question is:

```text
What does this asset reveal when combined with the rest of the repository?
```

That is why raw intake, quarantine, classification, sanitization, and final audit are separate steps.

## Cortado-system example

`cortado-system` is a System Field Manual.

Its public artifact is the documented coffee system, not the private photo roll used to build the documentation.

A practical workflow:

```text
assets/inbox/
assets/private-inbox/
assets/contact-sheets/
assets/gear/
assets/workflow/
assets/finished-drinks/
```

Raw photos of the counter, grinder, espresso machine, tools, cups, workflow steps, receipts, packaging, and finished drinks may first be collected into `assets/inbox/`.

Those files should then be moved into `assets/private-inbox/` and ignored.

A local contact sheet can be generated from `assets/private-inbox/` to review which images explain the system.

For larger asset sets, the contact sheet should number each thumbnail and show the original filename.

A local index should map each number back to the source filename so review can refer to images by stable integers.

Each image is classified as `public candidate`, `reference-only`, `discard`, or `needs crop/redaction`.

Only sanitized public-safe copies are renamed and copied into folders such as:

```text
assets/gear/
assets/workflow/
assets/finished-drinks/
```

The final repository should show the repeatable cortado system without publishing raw private intake, device metadata, home-context details, receipts, account information, map data, or unnecessary pattern-of-life context.

## References to connect later

This standard complements:

- `docs/repo-taxonomy.md`
- `prompts/publication-opsec-02-audit.md`
- `opsec-as-systems-thinking.md`

Future updates can add cross-references from the repository taxonomy and publication OPSEC audit prompt once this workflow has been used across more Field Manual repositories.
