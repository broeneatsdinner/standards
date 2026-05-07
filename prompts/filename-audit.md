# Filename Audit Prompt

Use this prompt when auditing a repository for filename and directory naming consistency.

Refer to the standards repository as the source of truth.

## Invocation instructions

Copy and paste this into Codex to run the filename audit against the current repository:

```text
Please use prompts/filename-audit.md as your operating prompt and apply it to this repository.

This is a filename-audit workflow run.

Audit the repository for filename and directory naming violations.

This is a report-only audit.

Do not rename, normalize, move, rewrite, delete, edit, or commit anything unless separately instructed.

Identify findings and remediation candidates only.

Recommend follow-up remediation workflows where appropriate.

After the audit, show me:

- filename and directory findings
- extension/content mismatches or MIME/type inconsistencies
- candidate remediations
- references that would need updates during remediation
- recommended follow-up workflow
- git status
- confirmation that you did not mutate the repository

Pay special attention to Markdown filename standards.
```

## Task

Audit the current repository for filename and directory naming issues.

Look for names that are:

- unclear
- inconsistent
- overly clever
- incorrectly cased
- using non-preferred extensions
- using extensions that do not match actual file type
- acting as vague junk-drawer names

Report findings and candidate remediations.

Do not mutate the repository during the audit.

## Standards to apply

Prefer filenames and directories that are:

- lowercase
- descriptive
- readable
- operationally clear
- consistent with surrounding files

Avoid vague junk-drawer directory names such as:

```text
misc/
stuff/
old/
new/
common/
utils/
helpers/
includes/
```

Unless the repository defines them very specifically.

Directory names should describe what files are, not vaguely how they are used.

## Extension standards

Use preferred canonical extensions.

README.md is the intentional conventional exception.

All other Markdown files should use lowercase filenames with a lowercase `.md` extension.

Good:

```text
README.md
shell-style.md
differentiator.md
```

Bad:

```text
DIFFERENTIATOR.MD
Differentiator.md
differentiator.MD
```

Known mappings:

```text
.jpg   not .jpeg
.html  not .htm
```

For media files, verify that the filename extension matches the actual file type when local tooling makes that possible.

Examples:

- `.jpg` files should contain JPEG data
- `.png` files should contain PNG data

Treat `.jpg` files containing PNG content as publication-quality defects.

Flag MIME/type inconsistencies, file-signature mismatches, and extension/content mismatches separately from naming-style issues.

These mismatches can break previews, MIME detection, static-site builds, automation, indexing, cache behavior, and downstream workflows.

Flag extension changes that would require reference, import, URL, build, deployment, or external-link updates.

Do not silently normalize media filenames as part of an unrelated audit or metadata remediation workflow.

Recommend media extension normalization only as an explicit follow-up remediation step, with affected references updated and verified during that remediation.

## Safety constraints

Do not edit files during the audit.

Do not reorganize the repository structure.

Do not rename, normalize, move, rewrite, delete, or commit anything.

Do not recommend renaming vendored, generated, archived, third-party, dependency, cache, or build-output files unless the repository clearly treats them as maintained source artifacts.

Flag files referenced by external systems as higher-risk remediation candidates.

When uncertain, report the uncertainty instead of implying remediation authority.

## Required workflow

1. Inspect the repository.
2. Audit filename and directory naming against the standards.
3. Check media extension/content consistency where tooling is available.
4. Identify candidate filename, directory, and normalization findings.
5. Identify references, imports, URLs, build paths, deployment paths, external links, manifests, indexes, or documentation paths that would need updates during remediation.
6. Recommend follow-up remediation or normalization workflows where appropriate.
7. Produce findings only.
8. Do not mutate the repository.

## Final report

When finished, report:

- filename findings
- directory findings
- candidate extension normalization findings
- extension/content mismatches or MIME/type inconsistencies found
- affected references or downstream surfaces that remediation would need to update
- unsafe or uncertain remediation candidates
- any recommended follow-up work
- git status
- confirmation that no files were renamed, normalized, moved, rewritten, deleted, committed, or otherwise changed

Do not commit anything.

Wait for explicit remediation approval before making changes.
