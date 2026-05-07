# Publication OPSEC Audit Prompt

Use this prompt when auditing a repository before making it public.

The goal is to identify OPSEC, privacy, identity, security, and personal-safety risks before publication.

Produce a report only.

Do not commit, delete, rewrite, redact, publish, rename, move, or otherwise modify anything unless separately instructed.

## Invocation instructions

Copy and paste this into Codex to run the publication OPSEC audit against the current repository:

```text
Please use prompts/publication-opsec-audit.md as your operating prompt and apply it to this repository.

This is a pre-publication OPSEC/security audit workflow run.

Audit the repository for OPSEC, privacy, identity, security, and personal-safety risks before publication.

Produce a report only.

Do not commit, delete, rewrite, redact, publish, rename, move, or otherwise modify anything.

Scan text, documentation, filenames, directory names, links, embedded URLs, images, videos, screenshots, maps, PDFs, other binary/media assets, metadata, and git history where possible.

After the audit, show me:

- summary risk rating
- findings by severity
- file/path references
- specific concern for each finding
- recommended remediation for each finding
- media and metadata findings
- raw/private asset intake findings
- whether each finding blocks publication
- files that appear safe
- audit limitations
- confirmation that you did not modify or commit anything
```

## Task

Audit the current repository before publication.

Look for anything that could expose private information, create security risk, reveal personal patterns, or reduce physical safety.

Report findings clearly enough that a human can decide what to remove, redact, rewrite, replace, or keep.

Do not make changes automatically.

## Scope

Inspect repository content and structure, including:

- text files
- README files
- documentation
- filenames
- directory names
- links
- embedded URLs
- screenshots
- images
- videos
- maps
- PDFs
- other binary/media assets
- EXIF and location metadata when possible
- git history when possible

Use available local tools where appropriate.

Examples include:

- repository search tools
- file listing tools
- image inspection tools
- metadata inspection tools
- git log and git grep

Do not install new tools or access network resources unless separately approved.

## Media asset metadata guidance

Identify image, video, screenshot, map, PDF, and other binary/media assets.

When tooling is available, inspect media and document metadata for:

- EXIF
- GPS/location data
- device make/model
- camera, app, or software names
- timestamps
- author/creator fields
- document history
- thumbnails or previews
- embedded coordinates

Treat screenshots as high-risk until reviewed for visible:

- browser tabs
- terminal paths
- account names
- map pins
- reflections
- documents
- receipts
- labels
- QR codes
- barcodes
- background details

Flag raw or private asset intake folders if they are tracked, staged, or otherwise prepared for publication.

Recommend keeping raw/private asset intake ignored, including:

- `assets/private-inbox/`
- `assets/inbox/` when used for raw unsorted intake

Recommend committing only curated public-safe copies.

Recommend stripping metadata from public images before commit.

If raw assets were ever committed, recommend reviewing git history for exposed metadata or visible private content.

Report media risks and recommended remediation only. Do not strip metadata, move files, delete files, rewrite history, or otherwise modify assets automatically.

## Risks to flag

Flag credentials and access material, including:

- credentials
- tokens
- API keys
- private keys
- session IDs
- cookies
- private URLs
- internal URLs
- private repository links
- editor, preview, share, or session URLs
- any other secrets

Flag personal and location information, including:

- home addresses
- approximate home locations
- nearby landmarks that reveal a home base
- school names
- daycare names
- workplace names
- child-related identifiers
- family member names when unnecessary for public release
- personal account identifiers
- phone numbers
- email addresses
- mailing addresses
- vehicle information

Flag pattern-of-life information, including:

- routine patterns
- timestamps
- schedules
- repeated activities tied to places
- routes
- maps
- trailheads
- parking areas
- campsite patterns
- recurring errands
- repeatable location behavior
- event timing that reveals habits or absence from home

Flag visible information in screenshots, images, maps, and visual assets, including:

- faces
- license plates
- mail
- labels
- receipts
- documents
- QR codes
- barcodes
- browser tabs
- browser history
- bookmarks
- terminal paths
- usernames
- hostnames
- IP addresses
- account identifiers
- device names
- Wi-Fi names
- map pins
- GPS coordinates
- street signs
- house numbers
- school logos
- workplace logos
- child-related materials

Flag unnecessary personal detail, even when it is not obviously sensitive.

If a detail is not needed for public readers, treat it as a possible removal or generalization candidate.

## Field Manual guidance

Apply extra scrutiny to Field Manual repositories.

Field Manual repositories may contain operationally useful material that becomes sensitive when public.

Review family activity manuals, maps, expedition docs, coffee and camp systems, screenshots, and visual assets for:

- home-base inference
- recurring departure or return locations
- routes from home to activity sites
- school, daycare, club, or child activity locations
- family names, ages, routines, preferences, and constraints
- exact campsites, trailheads, caches, water sources, or parking locations when unnecessary
- timestamps that reveal repeat usage patterns
- images that reveal people, vehicles, neighborhood details, mail, labels, receipts, documents, or account information
- maps that include private pins, saved places, route history, home markers, or precise coordinates
- screenshots that reveal browser tabs, terminal paths, usernames, hostnames, private accounts, or editor/session URLs
- documentation that turns private routines into repeatable public patterns

Prefer public-safe generalization where possible.

Examples:

- use region-level descriptions instead of home-adjacent locations
- use generalized route guidance instead of exact repeated routes
- remove personal names when roles are enough
- replace precise timestamps with broad seasons or conditions
- crop, blur, redact, or regenerate images that reveal unnecessary detail
- remove metadata from images before publication

## Git history guidance

When possible, inspect git history for previously committed sensitive content.

Look for:

- removed secrets
- old private URLs
- renamed files with sensitive names
- deleted images, maps, screenshots, or documents
- raw/private asset intake folders or files that were later moved or deleted
- media metadata from prior commits, including EXIF, GPS/location data, device/app fields, timestamps, author/creator fields, thumbnails, previews, document history, or embedded coordinates
- prior versions of README or docs that exposed personal information

Report history findings separately from current working tree findings.

If sensitive data appears in history, explain that deleting it from the current tree is not enough.

Recommend appropriate remediation, such as secret rotation, history rewriting, or repository recreation.

Do not rewrite history unless separately instructed.

## Severity

Classify findings by severity:

- Critical: credentials, secrets, private keys, session tokens, live private access, or exact home/child safety exposure that should block publication.
- High: precise private locations, routes, maps, faces, license plates, school/daycare/workplace identifiers, private account URLs, or strong pattern-of-life exposure.
- Medium: personal identifiers, usernames, hostnames, timestamps, approximate locations, visible documents, QR codes, barcodes, or unnecessary private context.
- Low: minor oversharing, weak identifiers, ambiguous metadata, or content that should be generalized for a cleaner public release.

Use judgment.

If uncertain, state the uncertainty and explain what would confirm the risk.

## Report format

Produce a report with these sections:

1. Summary
2. Findings by severity
3. Media and metadata findings
4. Raw/private asset intake findings
5. Git history findings
6. Files that appear safe
7. Limitations
8. Recommended next actions

For each finding, include:

- severity
- file or path reference
- location detail when available
- specific concern
- recommended remediation
- publication blocker: yes or no

If there are no findings in a severity level, say so.

If a file appears safe after review, list it briefly.

Do not claim the audit is exhaustive if image content, metadata tooling, binary formats, encrypted files, external links, or git history could not be fully inspected.

## Safety constraints

Do not commit anything.

Do not publish anything.

Do not delete anything.

Do not rewrite history.

Do not redact files.

Do not rename files.

Do not move files.

Do not edit files.

Do not access private external systems unless separately instructed.

Do not include secret values verbatim in the report.

When reporting a secret-like value, show only a short fingerprint or description.

Wait for explicit human review before any remediation.
