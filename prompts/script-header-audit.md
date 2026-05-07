# Repository Standards Audit Prompt

Use the standards repository as the source of truth for style, structure, and operator conventions.

Audit the current repository against those standards.

## Scope

Check for:

- script graphical headers
- one-line description comments
- run-directly vs sourced descriptions where applicable
- shell style consistency
- tabs for indentation and spaces for alignment
- comment style
- directory structure clarity
- README clarity
- reusable shell component opportunities

## Instructions

Make minimal edits only.

Preserve existing formatting unless a standards fix requires changing it.

Do not perform broad rewrites.

Do not rename files or directories unless explicitly asked.

When updating scripts, add graphical headers and descriptions only where they are useful and required by the standards.

If a file is too small, generated, vendored, third-party, or not meant to be maintained directly, leave it unchanged.

## Report

After changes, summarize:

- files changed
- standards applied
- files intentionally skipped
- anything that needs human review
