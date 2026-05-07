# Filename Audit Prompt

Use this prompt when auditing a repository for filename and directory naming consistency.

Refer to the standards repository as the source of truth.

## Task

Audit the current repository for filename and directory naming issues.

Look for names that are:

- unclear
- inconsistent
- overly clever
- incorrectly cased
- using non-preferred extensions
- acting as vague junk-drawer names

Make safe, minimal improvements where appropriate.

Do not commit anything yet.

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

Known mappings:

```text
.jpg   not .jpeg
.html  not .htm
```

Do not rename extensions if doing so would break references, imports, URLs, build tooling, deployment paths, or external links unless you also safely update every reference.

## Safety constraints

Make minimal edits only.

Preserve existing formatting.

Do not reorganize the repository structure unless explicitly asked.

Do not rename vendored, generated, archived, third-party, dependency, cache, or build-output files.

Do not rename files referenced by external systems unless you can safely update the references.

When uncertain, do not rename. Report the issue instead.

## Required workflow

1. Inspect the repository.
2. Identify candidate filename and directory issues.
3. Apply only safe, obvious renames.
4. Update internal references when a safe rename requires it.
5. Leave uncertain cases unchanged.
6. Report what changed and what was skipped.

## Final report

When finished, report:

- files renamed
- directories renamed
- references updated
- items intentionally skipped
- unsafe or uncertain rename candidates
- any recommended follow-up work

Do not commit the changes.

Wait for review before committing.
