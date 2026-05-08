# typography assets

Reusable CSS and HTML fixtures for rendering exported Markdown into branded, readable, publishable formats.

These assets support conversion workflows such as:

- AI chat export -> Markdown -> HTML/PDF
- Google Docs export -> Markdown -> HTML/PDF
- formal notes/writeups -> Markdown -> HTML/PDF

The goal is not to create decorative pages.

The goal is to make exported technical material readable, consistent, reviewable, and safe to publish.

## Purpose

`assets/typography/` contains typography systems for common exported-document shapes.

Each system has a reusable stylesheet and one or more HTML fixtures. The fixtures are not application pages. They are reference documents for inspecting spacing, hierarchy, component coverage, and print/PDF behavior.

The styles should be restrained, operator-readable, and suitable for public standards material. They should make Markdown output look intentional without hiding the structure of the source material.

## Chat Typography

Chat typography is for exported AI conversations and transcripts.

It is intended for workflows where an AI conversation is exported, normalized to Markdown, and rendered as static HTML or PDF for review, publication, or archival use.

Current chat files:

- `chats.css` is the reusable stylesheet for chat and transcript rendering.
- `chats-tearsheet.html` is the component coverage fixture for chat export elements.
- `chats-conversation.html` is a realistic usage example showing a developer and AI assistant conversation flow.

The chat system covers message roles, transcript metadata, user bubbles, assistant prose, system/developer/tool notes, code blocks, command blocks, terminal output, diff output, tables, callouts, path chips, citations, images, and print behavior.

## Document Typography

Document typography is for formal document rendering.

It is intended for Markdown converted from Google Docs, formal notes, standards writeups, operating procedures, and public documentation that should read like a document rather than a transcript.

Current document files:

- `documents.css` is the reusable stylesheet for formal documents rendered from Markdown.
- `documents-tearsheet.html` is the component coverage fixture for headings, lists, tables, quotes, footnotes, footers, page behavior, and related document elements.

The document system covers title pages, subtitles, author/date metadata, heading hierarchy, paragraphs, emphasis, links, lists, nested lists, blockquotes, pull quotes, tables, captions, footnotes, citations, callouts, code snippets, appendices, footer areas, page breaks, and print/PDF behavior.

## Tear Sheets and Usage Examples

A tear sheet is exhaustive component coverage.

Use a tear sheet to inspect whether every supported Markdown or export element has a defined visual treatment. Tear sheets should include edge cases and component variants even if the resulting page does not read like a natural document.

A usage example demonstrates realistic flow and readability.

Use a usage example to inspect whether the typography still works when the content reads like a real exported conversation or document. Usage examples should feel plausible, coherent, and safe for public publication.

## Workflow

The intended workflow is:

1. Export source material to Markdown.
2. Convert Markdown to HTML using the appropriate stylesheet.
3. Inspect the matching tear sheet or generated output in a browser.
4. Print or save to PDF when needed.
5. Tune CSS against both screen and PDF output.

Screen rendering and PDF rendering are both part of the standard. A style that works in the browser but breaks tables, figures, code blocks, callouts, or headings across pages is not finished.

## Standards

Typography assets follow the same repository standards as the rest of this project:

- lowercase filenames except `README.md`
- no private identifiers, secrets, GPS data, tokens, keys, or sensitive logs
- sanitized examples only
- clear class names
- restrained, readable visual design
- print/PDF behavior considered part of the standard

Examples should teach the shape of the workflow without exposing live operational details.

## Future Expansion

Possible future additions:

- visual regression screenshots
- PDF examples
- additional document templates
- citation variants
- long-form stress tests
- dark mode only if needed
