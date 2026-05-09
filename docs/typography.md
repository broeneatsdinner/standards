# Typography

This document is the initial standards home for typography and PDF-oriented output.

It defines the direction for readable Markdown-to-HTML and Markdown-to-PDF material without freezing final visual design too early.

## Purpose

Typography standards should make exported and generated material readable, consistent, reviewable, and publication-ready.

The goal is not decoration. The goal is to preserve structure, hierarchy, evidence, and context when source material moves from Markdown or exported HTML into archival PDFs, review packets, reports, or public documentation.

Typography work should support both screen inspection and PDF output. A style that looks acceptable in a browser but breaks page flow, tables, code blocks, callouts, captions, or metadata in PDF output is not complete.

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
