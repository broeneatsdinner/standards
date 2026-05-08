# Script Content Standards

This document covers comments, examples, workflow notes, directory trees, and
other documentation that appears inside the body of scripts.

For top-of-file script identity, graphical headers, shebangs, and
`# description:` conventions, see `docs/script-headers.md`.

## Commented Directory Trees

When including an example directory tree inside source-code comments, the tree
does not need to be literal command output. It should prioritize readability,
orientation, and the purpose of the surrounding script or document.

A commented directory tree is documentation, not a forensic transcript. It may
be curated, shortened, reordered, or explained outside the tree when doing so
makes the workflow easier to understand.

### Purpose

Use commented directory trees to show:

- expected working-directory layout
- required input directories
- generated output directories
- where the current script belongs
- which files are preserved versus produced
- how a user should orient themselves before running the script

### Rules

- Prefix every line with the comment marker used by the file.

- Show the command/context line above the tree when useful, especially when the
  current working directory matters.

- Place the primary script, executable, or primary artifact first when it is the
  reason the tree is being shown.

- Within each directory level, list files before subdirectories. This applies at
  the root and inside nested directories. Use this ordering so scripts, README
  files, config files, manifests, and other source artifacts are visible before
  supporting folders.

- When separating files from subdirectories within the same directory level, use
  the appropriate commented vertical tree connector line instead of a blank
  commented line. For example, use "# │" at the root level, or "# │   │" at a
  nested level, so the tree still reads as a continuous structure.

- The separator belongs to the directory level, not to the file above it. Do not
  use a tree connector line that visually makes a file appear to have children.

- Do not use tree connector glyphs under a file except as an intentional
  directory-level separator. A connector continuing below a file can imply that
  the file has children, which is structurally misleading.

- Add trailing slashes to directory names.

- Do not add inline explanatory notes inside the tree itself.

- Put explanatory notes before or after the tree instead.

- Prefer exhaustive trees when the full tree remains readable.

- Include every file and directory that belongs to the documented workflow.

- Omit files only when they are unrelated to the documented workflow, excessive
  in number, or likely to obscure the purpose of the tree.

- When a tree is shortened, say so explicitly outside the tree.

- Prefer stable example filenames when a representative tree is explicitly being
  used.

- Prefer clarity over literal `tree` command fidelity when documenting expected
  layout.

### Good example

# For reference, this is an exhaustive example directory tree after the script
# has generated final-1024-png and icns outputs:
#
# Example, from the working directory:
#
# $ tree
# .
# ├── README.md
# ├── rebuild_icns_from_wonder.sh
# │
# ├── examples/
# │   ├── README.md
# │   ├── run_example.sh
# │   │
# │   ├── input/
# │   │   ├── Favorites.png
# │   │   └── Get Info.png
# │   └── output/
# │       ├── Favorites.icns
# │       └── Get Info.icns
# ├── final-1024-png/
# │   ├── Favorites.png
# │   └── Get Info.png
# ├── icns/
# │   ├── Favorites.icns
# │   └── Get Info.icns
# ├── source-png/
# │   ├── Favorites.png
# │   └── Get Info.png
# └── upscaled-png/
#     ├── Favorites-topaz-wonder.png
#     ├── Favorites.png
#     ├── Get Info-topaz-wonder.png
#     └── Get Info.png

### Notes

The vertical connector line after the files in the root directory is
intentional. It separates root-level files from the directory workflow they
operate on while preserving the visual continuity of the tree.

The same separator pattern applies inside nested directories. In the example,
the "# │   │" line separates files inside examples/ from the examples/
subdirectories.

The directory slashes are intentional. They make it clear that examples,
final-1024-png, icns, source-png, and upscaled-png are directories, not files.

Do not include personal shell prompts, usernames, hostnames, machine names, home
paths, project paths, or other environment-specific identifiers in reusable
examples. Use a neutral prompt such as "$" unless the exact prompt is part of
the subject being documented.
