# Filename Audit Prompt

Use this prompt when auditing a repository for filename, directory-name, extension, and file-type consistency.

The goal is to identify issues and remediation candidates.

Produce a report only.

This prompt does not grant mutation authority.

Do not rename, normalize, move, rewrite, delete, edit, publish, commit, or otherwise modify anything.

## Invocation instructions

Copy and paste this into Codex to run the filename audit against the current repository:

```text
Please use prompts/filename-02-audit.md as your operating prompt and apply it to this repository.

This is the audit phase for a filename workflow.

Audit the repository for filename and directory naming violations.

Use docs/workflow-architecture.md and docs/media-asset-workflow.md as workflow context.

This is a report-only audit.

Do not rename, normalize, move, rewrite, delete, edit, publish, or commit anything.

Identify findings and remediation candidates only.

Recommend follow-up remediation workflows where appropriate.

After the audit, show me:

- filename and directory findings
- extension/content mismatches or MIME/type inconsistencies
- candidate remediations
- references and downstream systems that would need updates during remediation
- unsafe or uncertain remediation candidates
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

## Required references

Use these files as operating context:

- `docs/workflow-architecture.md`
- `docs/media-asset-workflow.md`
- `prompts/filename-03-remediate.md`

Use `docs/workflow-architecture.md` to preserve the report-only audit boundary.

Use `docs/media-asset-workflow.md` when reviewing media assets, public-safe asset names, extension standards, raw/private intake paths, and curated public copies.

Use `prompts/filename-03-remediate.md` only as a possible approved follow-up workflow.

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

Do not silently normalize media filenames as part of an audit or metadata remediation workflow.

Recommend media extension normalization only as an explicit follow-up remediation step, with affected references updated and verified during that remediation.

## Reference and downstream impact review

Identify affected references and downstream systems for each remediation candidate when practical.

Check for:

- Markdown links
- image references
- imports
- URLs
- build paths
- deployment paths
- manifests
- indexes
- static-site routes
- documentation paths
- generated previews
- external references called out by the repository

Do not update these references during the audit.

Report which references would need to be updated during remediation.

## Safety constraints

Do not edit files during the audit.

Do not reorganize the repository structure.

Do not rename, normalize, move, rewrite, delete, publish, or commit anything.

Do not recommend renaming vendored, generated, archived, third-party, dependency, cache, or build-output files unless the repository clearly treats them as maintained source artifacts.

Flag files referenced by external systems as higher-risk remediation candidates.

When uncertain, report the uncertainty instead of implying remediation authority.

## Required workflow

1. Inspect the repository.
2. Audit filename and directory naming against the standards.
3. Check media extension/content consistency where tooling is available.
4. Identify candidate filename, directory, and normalization findings.
5. Identify references, imports, URLs, build paths, deployment paths, external links, manifests, indexes, or documentation paths that would need updates during remediation.
6. Identify downstream systems that could be affected by remediation.
7. Recommend follow-up remediation or normalization workflows where appropriate.
8. Produce findings only.
9. Do not mutate the repository.

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
