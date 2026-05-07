# Filename Audit Prompt

Use the standards repository as the source of truth for filename and directory naming conventions.

Audit the current repository for filename consistency, clarity, and naming hygiene.

## Goals

Improve:

- readability
- predictability
- consistency
- navigability
- operator clarity

Reduce:

- ambiguity
- junk-drawer naming
- inconsistent casing
- inconsistent extensions
- unclear directory purpose

## Filename standards

Prefer filenames that are:

- lowercase
- descriptive
- readable
- operationally clear
- consistent with surrounding files

Avoid filenames that are:

- vague
- overly clever
- inconsistent
- redundant
- difficult to scan quickly

## Extension standards

Use the preferred canonical extension for each file type.

Current standards include:

```text
.jpg   not .jpeg
.html  not .htm
```

Do not rename extensions that would break external tooling, URLs, imports, references, or APIs without updating references safely.

## Directory naming standards

Directory names should describe what the files are, not vaguely how they are used.

Avoid vague junk-drawer directories such as:

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

Prefer names that clearly describe the contents.

Examples:

```text
php/
css/
js/
python/
assets/
output/
logs/
```

## Safety rules

Make minimal changes only.

Do not rename files unnecessarily.

Do not reorganize the repository structure unless explicitly asked.

Do not rename externally referenced files without updating references safely.

When uncertain whether a rename is safe, report it instead of changing it.

## Report

After the audit, summarize:

- renamed files
- renamed directories
- skipped items
- possible unsafe renames
- naming inconsistencies that need human review
