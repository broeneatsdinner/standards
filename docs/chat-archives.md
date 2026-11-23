# Chat archives and reading PDFs

An exported conversation has two different jobs: preserve what was said and make it comfortable to read later. Keep the original export as evidence. Create the PDF as a separate reading edition, with its provenance and limits visible.

This standard applies to LLM conversations supplied as Markdown or obtained from a provider export. It does not grant access to another account, authorize publication, or establish that an assistant's claims about completed actions are true.

## Archive the source first

1. Identify the conversation and the intended archive repository. Personal material belongs in an appropriate private archive, not in this public standards repository.
2. Prefer a provider-issued export for comparison. A third-party exporter or copied Markdown can be a useful provisional source. Record which method produced the file and when it was captured.
3. Check the available beginning and end, message counts, duplicates, failed attempts, branches, attachments, and links. Follow every available continuation cursor. A reader returning no more pages does not prove that its bounded view contains the whole original conversation.
4. Copy the supplied file without changing its bytes. Give the archived copy a stable lowercase filename, record the original filename, and calculate its SHA-256 before and after filing. Preserve intentional Markdown whitespace and exporter quirks.
5. Write a brief archive note describing the source, comparison performed, gaps, and attachment availability. Keep recollection, interpretation, editorial changes, and later correspondence separate from the primary source.

Never reconstruct missing messages, remove repeated prompts, invent missing responses, sort ambiguous timestamps, clean up wording, or silently normalize the original. Preserve the exported order. Record timestamps and timezone information as supplied; do not infer a timezone from the machine doing the conversion.

An export containing a coherent narrative is not automatically complete. Neither matching message counts nor a checksum verifies the provider's entire record. A checksum establishes which exact file was preserved. Source verification requires comparison with the original record, including any known attachment or branch limits. Hidden instructions or unavailable branches must not be claimed as archived.

## Suggested archive layout

Adapt the enclosing path to the destination repository's existing structure. A dated personal archive entry can use:

```text
entries/yyyy/yyyy-mm-dd-topic/
    README.md
    primary/
        chat/
            conversation-export.md
    output/
        pdf/
            conversation.pdf
            conversation.render.json
```

The README records provenance and provides the reading link. The Markdown remains the immutable source. The PDF and render report are derivatives. Preserve a later official export as another primary source; do not overwrite the provisional export with it.

Only create directories that have a purpose. If the archive repository has no remote, apply [repository backup guidance](git-repository-backups.md). For byte-preserved primary sources, use an appropriate `.gitattributes` rule such as `entries/**/primary/** -text` to prevent line-ending conversion. Review all proposed files before committing; storing an archive privately and publishing it are separate decisions.

## Routine typography

The routine file-based reading edition uses the Nothing Sans reading setting: Light body copy at 13 pt with 1.46 leading, Book labels, SemiBold emphasis, a short Bold cover title, zero letter spacing, US Letter pages, and quiet running headings and page numbers. Code uses JetBrains Mono. See [Nothing Sans](nothing-sans.md) and [typefaces](typefaces.md) for the settings and licensing boundary.

This is the selected archive-reading profile. The existing system-font chat component fixtures and document typography remain available for their established purposes; this workflow does not silently restyle them.

Nothing Sans files are supplied locally by the license holder, remain ignored, and are never committed as standalone files. The PDF embeds subsets only for authorized use. Do not embed San Francisco in PDFs. The converter isolates its font configuration and rejects unexpected substitutions. Source characters absent from the configured fonts stop conversion rather than being replaced. Supply a locally available, appropriately licensed emoji font with `--emoji-font` when needed. A local Noto Emoji font is also discovered at `.local/chat-pdf/noto-emoji.ttf`; keep its OFL license beside it. No font is downloaded during rendering.

## Install the converter dependencies

Run from a local standards checkout. These commands create an ignored environment; they do not install into the system Python:

```sh
python3 -m venv .venv-chat-pdf
.venv-chat-pdf/bin/python -m pip install -r assets/typography/chat-pdf-requirements.txt
```

Pandoc, Poppler (`pdfinfo`, `pdffonts`, `pdftoppm`), and WeasyPrint's native Pango libraries must also be available. Use a supplied workspace runtime when it already provides them. On macOS with Homebrew, a typical native setup is:

```sh
brew install pandoc pango poppler
```

If the macOS loader cannot find the Pango libraries, set their location for the command rather than changing a global shell profile:

```sh
export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib"
```

The font directory defaults to `assets/typefaces/sansserif/` in the standards checkout. It must contain the Light, LightItalic, Book, BookItalic, SemiBold, SemiBoldItalic, and Bold Nothing Sans OTF files. An alternate local directory can be supplied with `--font-dir`. JetBrains Mono comes from the repository's open-licensed `assets/typefaces/monospace/` directory. Keep its license with any copied standalone files.

## Render a supplied Markdown file

The executable is [`bin/render-chat-pdf`](../bin/render-chat-pdf). With no arguments it prints usage and makes no changes. For the `## Prompt:` / `## Response:` exporter format:

```sh
.venv-chat-pdf/bin/python bin/render-chat-pdf /path/to/conversation-export.md --output /path/to/conversation.pdf --source-label "Third-party Markdown export"
```

Paths above are placeholders. The output must differ from the source. Existing PDFs and reports are refused unless `--force` is supplied; use that option only for a deliberate replacement of derivatives.

For another Markdown shape, render the whole document without inventing message roles:

```sh
.venv-chat-pdf/bin/python bin/render-chat-pdf /path/to/conversation.md --format markdown --output /path/to/conversation.pdf
```

The exporter adapter uses parsed Markdown headings, so headings inside fenced code remain code. It preserves repeated prompts and unequal user/assistant counts. `--format markdown` reports no inferred message count. Other provider export formats, provider JSON imports, automatic conversation extraction, and branch reconciliation are outside this converter's current scope.

The source status defaults to `unverified`. Use `--source-status partial` for a known partial source. `--source-status compared` requires a `--comparison-note` describing the evidence and remaining limits. This is an operator-reported source status, not a verification that the renderer performs or a claim that every provider message exists in the source.

The converter:

- Reads the source without modifying it, disables Markdown smart-punctuation rewriting, and treats raw HTML and TeX as source text rather than executable content.
- Preserves exported order, text, Markdown structure, timestamps, model labels, and supported links. Cover notes and speaker labels are explicitly part of the derivative.
- Represents images as linked descriptions. For a linked image, both the image destination and the surrounding link remain available. No remote image or other source resource is fetched.
- Replaces supported image-group components with descriptive notices containing their exported queries. Unsupported characters or components that cannot be rendered faithfully require review; do not invent replacements.
- Keeps HTTP, HTTPS, mailto links, and internal anchor and footnote jumps clickable. Other targets, including relative filesystem links and active-content schemes, become visibly inactive descriptions. This prevents local path resolution and active content in the reading edition; original URLs remain in the unchanged source.
- Checks extracted PDF text in order, link destinations, page bounds, source SHA-256, and embedded fonts before installing the output.
- Writes a `.render.json` report beside the PDF with message counts when available, transformation counts, source and PDF hashes, dependency and stylesheet versions, font hashes, and check results. It records visual review as pending.

The report deliberately omits absolute source and font paths. The PDF and report still contain source-derived titles, filenames, text, and link destinations; they are not automatically sanitized public artifacts.

## Review the actual PDF

Use the synthetic [component fixture](../examples/chat-archive/conversation-export.md) when changing the renderer or stylesheet. Keep private transcripts out of public fixtures and test logs.

With the local fonts and dependencies available, run the preservation and failure-boundary checks from the standards root:

```sh
.venv-chat-pdf/bin/python -m unittest discover -s tests -p test_chat_pdf.py -v
```

Inspect the generated PDF, not just HTML or extracted text:

```sh
pdfinfo /path/to/conversation.pdf
pdffonts /path/to/conversation.pdf
pdftoppm -scale-to 1200 -png /path/to/conversation.pdf /path/to/private-review/page
```

Create the private review directory first. Review every page, using contact sheets for long transcripts and full-size pages for small text or suspected defects. Check speaker transitions, headings near page ends, paragraph flow, tables, code, long URLs, emphasis, images and captions, glyphs, page numbering, and the beginning and final source passage. Open representative links. Re-render after any layout change and repeat the affected review. Test-print at 100% when a physical print edition is intended.

Automated text extraction can miss visual defects; bounds checks cannot establish readable spacing. Text comparison normalizes whitespace, Unicode compatibility forms, and nonprinting variation selectors; it does not prove the visual appearance of a glyph. Passing the renderer's checks is not visual approval. Record visual-review completion and limitations in the entry README without rewriting the automatically generated report's checks.

## Public reuse and completion

Public standards contain the generic method, converter, and synthetic examples. Real conversations, account exports, email addresses, personal names, private repository names, signed attachment URLs, review screenshots, and source-specific manifests stay in the appropriate private archive.

For an intentionally public derivative, create a separate reviewed copy. Review visible content, hyperlinks, PDF metadata, attachments, local paths, and git history under the [OPSEC audit](../prompts/repository-opsec-02-audit.md) and [media asset workflow](media-asset-workflow.md). Metadata stripping alone does not sanitize a transcript or its link annotations. Do not redact or overwrite the only primary source as a publication step.

A completion report states where the unchanged source was filed, where the reading PDF and report are, what checks and visual review passed, whether comparison with the full original remains pending, and the actual commit/push state when relevant. Never call a complete-conversation export finished solely because a PDF was produced.
