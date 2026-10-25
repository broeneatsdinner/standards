# Typography

This document is the initial standards home for typography and PDF-oriented output.

It defines the direction for readable Markdown-to-HTML and Markdown-to-PDF material without freezing final visual design too early.

## Purpose

Typography standards should make exported and generated material readable, consistent, reviewable, and publication-ready.

The goal is not decoration. The goal is to preserve structure, hierarchy, evidence, and context when source material moves from Markdown or exported HTML into archival PDFs, review packets, reports, or public documentation.

Typography work should support both screen inspection and PDF output. A style that looks acceptable in a browser but breaks page flow, tables, code blocks, callouts, captions, or metadata in PDF output is not complete.

## Which typography standard applies

The standards repository has four typography systems, and the brand face has two registers: one for reading, one for posters and print. Pick by what is being made, then follow that system's own document.

| Making | System | Faces | Authority |
| --- | --- | --- | --- |
| A Nothing LLC or Howblue Ltd web page, or a project photo site | Nothing Sans brand setting | Nothing Sans (Light, Book, SemiBold, Bold) | [docs/nothing-sans.md](nothing-sans.md), [`assets/typefaces/nothing-sans.css`](../assets/typefaces/nothing-sans.css), [docs/photo-sites.md](photo-sites.md) |
| A poster, cover, or other print or display piece | Nothing Sans poster register | Nothing Sans (Book, Medium, Bold, ExtraBold) | "The poster register" in [docs/nothing-sans.md](nothing-sans.md#the-poster-register), [`assets/typography/nothing-poster-specimen.html`](../assets/typography/nothing-poster-specimen.html) |
| A chat export, transcript, report, or formal document rendered to HTML or PDF | Chat and document typography (this document) | System UI fonts | this document, [`assets/typography/`](../assets/typography/) |
| A repository's GitHub Pages manual | Pages kit | System UI fonts | [docs/github-pages-guidelines.md](github-pages-guidelines.md), [`pages/github-pages-docs-site/`](../pages/github-pages-docs-site/) |
| A spreadsheet, gear ledger, or a discussion of type choices | Typeface reference set | Tiempos Text, Söhne, Proxima (documented, not licensed) | [docs/typefaces.md](typefaces.md) |

Across all of them, terminals, code, and number-heavy tables use the fixed-width face, `JetBrainsMono NFM` ([docs/typefaces.md](typefaces.md)).

Chat, document, and Pages typography keep the system fonts, for text and for code. A tear-sheet pass in October 2026 compared them against JetBrainsMono NFM for code alone, and Nothing Sans (Book, and Light paragraphs) for text with JetBrainsMono for code; the system fonts were kept on taste. Revisit only with a new reason, and with the same side-by-side comparison, not by swapping the font stacks.

## Typography Domains

This repository has two primary typography domains.

### Chat Typography

Chat typography is for AI chat conversations, chat exports, chat-derived Markdown, and readable archival PDFs generated from chat material.

It should preserve the conversational structure of the source material while making long transcripts easier to scan, review, cite, and archive.

Chat typography may include message roles, transcript metadata, assistant and user turns, tool output, code blocks, command output, citations, callouts, and other elements common in AI-assisted work.

### Document Typography

Document typography is for office-style documents, reports, formal writeups, and operational documentation.

Security audit reports use document typography, not chat typography. That includes authorized surface scan reports, nmap reports, open-port reports, firewall reports, red-team reports, and remediation reports.

Document typography should support formal hierarchy, evidence presentation, metadata, findings, tables, code or command excerpts, notes, captions, appendices, and PDF review.

### Document Cover Pages

A document cover page should establish identity, scope, and authority without trying to summarize the whole report.

Cover pages should communicate quiet authority and feel like artifacts of record rather than dashboards or marketing flyers.

Use a sparse layout with one primary title block and one compact metadata block where appropriate. Preserve generous empty space around the title and metadata, and do not fill the cover just because space is available.

An optional subtle identity mark, system mark, or line motif may appear on the cover. The mark may bleed or nearly bleed off the left edge. Decorative elements should remain secondary to the document identity and metadata.

The top of the identity mark, title block, and upper metadata block should align visually along the same horizontal axis. The top offset should be deliberate and consistent across cover-page variants, but exact top-offset measurements should not be defined until page size, font scale, and PDF rendering behavior have been tested in implementation specimens.

Avoid dashboard cards, metric tiles, alert badges, dense executive-summary panels, stock-photo hero imagery, and alarmist security imagery on document covers by default.

Cover page structure should follow this order:

1. Top identity band: optional edge-bleed identity mark at upper left, primary title in the upper third, and compact metadata block at upper right with top edges visually aligned.
2. Main information area: controlled-width text blocks below the identity band for recipient, client, scope, target, project, report classification, or a short report description.
3. Footer or author area: optional author, team, contact, version, classification, or publication-status metadata kept quiet and secondary.
4. Negative space: large open areas preserved as part of the design, not treated as unused space to fill.

Security report covers should support report title, assessment type, scoped target or sanitized target placeholder, client or project, date, author, operator or team, confidentiality or publication status, and optional version.

Security report covers should not lead with severity counts, open-port counts, exploit icons, red-alert panels, finding cards, dashboard widgets, or decorative cyber clichés. Those belong in an executive summary, findings section, or dashboard artifact, not the default cover page.

### Document Interior Pages

Document interior pages should feel like formal report pages or publication pages: calm, structured, readable, and suitable for PDF review.

Use generous page margins for PDF output and a controlled body-text measure rather than full-width body text. Body copy should remain visually calm and readable for long-form material.

A quiet running header near the top margin may be used when useful. Running headers should be small, light, and secondary to page content.

Use a clear page or report title with deliberate space above and below it. Page titles should have more space around them than ordinary section headings.

Major section headings should have visible space above them and may use a thin horizontal rule beneath them. Use divider rules sparingly, mainly for major section boundaries, and do not place divider lines after every heading by default.

Subsection headings should be smaller than major section headings. They should sit closer to the text they introduce than to the previous section.

Body paragraphs should maintain consistent vertical rhythm.

Footers may use a thin rule to separate page metadata from body content. Footer metadata and page numbers should remain quiet and secondary. Page numbers, document title, version, classification, or copyright metadata should not compete with the body.

For security report interior pages, findings should be visually distinct but not alarmist. Severity should be scannable without dominating the page.

Evidence blocks should be clearly separated from prose without feeling like raw terminal dumps. Remediation sections should be easy to scan, and command output or technical excerpts should remain readable in PDF form.

Tables should remain readable and should not force the page into a dashboard aesthetic. Avoid heavy boxes, alert panels, excessive dividers, and decorative cyber styling inside prose-heavy report pages by default.

Interior typography should be validated with tear sheets that include:

- long body paragraphs
- major sections
- subsections
- divider rules
- tables
- code blocks
- command output
- notes or callouts
- captions
- footers and page metadata

## Tear Sheets

A tear sheet is a typography specimen for component coverage.

Use tear sheets to verify that supported Markdown and exported-document elements have defined treatments before broad CSS changes are made. Typography specimens should be updated or created first, then CSS should be tuned against those specimens.

Expected tear sheet coverage includes:

- H1, H2, and H3 headings
- paragraphs
- emphasis
- links
- unordered lists
- ordered lists
- code spans
- code blocks
- tables
- blockquotes
- callouts and notes
- captions
- metadata

Tear sheets may include edge cases and variants even when the result does not read like a natural document. Their job is coverage, not narrative flow.

## Markdown-to-PDF Orientation

Markdown-to-PDF workflows are part of the standard.

Document PDF output should default to US Letter, 8.5 inches by 11 inches, unless a project or recipient explicitly requires another page size. Typography specimens for document output should be evaluated against US Letter by default. Other page sizes may be used intentionally, but should be specified by the project or output workflow.

Styles should be evaluated against the path from source Markdown or exported content to HTML and then to PDF. Screen rendering is useful for inspection, but PDF output is a first-class target when the material is archival, reviewable, client-facing, or publication-oriented.

Typography should keep source structure visible. It should not hide weak hierarchy, ambiguous metadata, broken tables, unreadable code, or missing captions behind visual polish.

## Relationship to Assets

`assets/typography/` contains reusable CSS and HTML fixtures for the current typography systems.

Current chat typography assets include:

- `assets/typography/chats.css`
- `assets/typography/chats-tearsheet.html`
- `assets/typography/chats-conversation.html`

Current document typography assets include:

- `assets/typography/documents.css`
- `assets/typography/documents-tearsheet.html`

The assets are implementation fixtures. This document is the standards authority. When the assets and this standard disagree, update the standard or the assets intentionally rather than letting the mismatch drift.

## Evolution

This is intentionally a first-pass standard.

It should evolve as the typography assets mature, as PDF workflows become more repeatable, and as real chat archives, office-style documents, and security reports reveal missing component coverage.
