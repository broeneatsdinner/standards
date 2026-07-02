# Standards Sync

## Purpose

The standards sync system installs and refreshes selected files from the
standards repository into consumer repositories.

It is intended for explicit promotion: standards are developed in the standards
repo, copied into a consumer repo as vendored files, reviewed as a normal Git
diff, and then committed intentionally by the operator.

The sync tool does not add files to Git, commit, push, or make publication
decisions.

## Design Overview

`bin/install-standards` is the canonical installer and sync engine in the
standards repo.

When standards support is installed into a consumer repo, the installer creates:

- `bin/sync-standards`, a repo-local shim for refreshing vendored standards.
- `.standards-sync`, a manifest declaring which files to copy.
- `vendor/standards/`, the default destination for vendored standards files.

The consumer repo owns its manifest. The standards repo owns the source files
and the sync engine.

The copied files are plain files in the consumer repo. They are reviewable,
publishable, and do not require the standards repo to be present for readers of
the consumer repo.

## Repository Roles

The standards repo is the source of truth for reusable standards, scripts, and
support files.

The consumer repo is any repo that wants a local copy of selected standards
files. It declares those files in `.standards-sync` and receives copies under
`vendor/standards/` or another destination named in the manifest.

The local operator environment may know where the private standards checkout
lives. That location should stay in ignored shell configuration, not in
consumer-repo files.

## Command Reference

From the standards repo, install support into a consumer repo:

```bash
$ bin/install-standards <target-repo>
```

The explicit equivalent is:

```bash
$ bin/install-standards install <target-repo>
```

From a consumer repo, refresh vendored standards:

```bash
$ bin/sync-standards
```

From the standards repo, sync a specific consumer repo directly:

```bash
$ bin/install-standards sync <target-repo>
```

From the standards repo or from a consumer repo with the installer available,
show sync status:

```bash
$ bin/install-standards status <target-repo>
```

After syncing, review changes:

```bash
$ git --no-pager diff
```

The sync engine also prints a narrower review command:

```bash
$ git --no-pager diff -- .standards-sync vendor/standards
```

## Manifest Format

The manifest file is `.standards-sync` in the consumer repo.

Each non-comment entry uses this format:

```text
source/path -> destination/path
```

The source path is relative to the standards repo. The destination path is
relative to the consumer repo.

Example:

```text
# Files synced from the standards repo into this repository.
# Format:
# source/path -> destination/path

shell/colors.sh -> vendor/standards/shell/colors.sh
bin/install-standards -> vendor/standards/bin/install-standards
```

Blank lines are ignored. Text after `#` is treated as a comment.

The default destination is `vendor/standards/`, but the manifest format allows
another destination when a repo has a specific reason to use one.

## Private Path / OPSEC Boundary

Do not commit a private local path to the standards repo into a consumer repo.

Consumer repos should be publishable. A reader should see the vendored files,
the manifest, and the sync shim, not an operator's workstation layout.

On a local machine, define the standards checkout path in private, ignored shell
configuration:

```zsh
export STANDARDS_REPO="$HOME/Documents/Git/standards"
```

For example, that setting can live in a private shell config such as:

```text
~/.dotfiles/local/private.zsh
```

The repo-local `bin/sync-standards` shim can use `STANDARDS_REPO` when the
vendored installer is missing or when a local standards checkout should be used
as the source. The variable belongs to the operator environment, not to the
consumer repo.

## First-Time Install Workflow

1. Develop or update standards in the standards repo.
2. From the standards repo, install sync support into the consumer repo:

```bash
$ bin/install-standards <target-repo>
```

3. In the consumer repo, inspect the new files:

```bash
$ git --no-pager diff
```

4. Adjust `.standards-sync` if the consumer repo needs additional or fewer
   files.
5. Run the repo-local sync shim after manifest edits:

```bash
$ bin/sync-standards
```

6. Review, then commit and push intentionally.

## Ongoing Sync Workflow

1. Develop or update standards in the standards repo.
2. In the consumer repo, refresh vendored files:

```bash
$ bin/sync-standards
```

3. Review the copied changes:

```bash
$ git --no-pager diff
```

4. Run any repo-specific validation that applies.
5. Commit and push intentionally.

## Why Sync Does Not Auto-Commit

Syncing copies files. Publishing changes is a separate operator decision.

Keeping those steps separate makes the diff reviewable before promotion. It
also lets the consumer repo run its own checks, adjust the manifest, reject a
bad sync, or combine the vendored update with related local changes when that is
the right commit shape.

The sync system should make standards easy to promote, not promote them
invisibly.

## Example Layout In A Consumer Repo

```text
.
├── .standards-sync
├── bin/
│   └── sync-standards
└── vendor/
    └── standards/
        ├── bin/
        │   └── install-standards
        └── shell/
            └── colors.sh
```

The exact files under `vendor/standards/` depend on `.standards-sync`.

## Troubleshooting

### Missing `STANDARDS_REPO`

If `bin/sync-standards` cannot find the installer, it looks for:

- `./vendor/standards/bin/install-standards`
- `./standards/bin/install-standards`
- `$STANDARDS_REPO/bin/install-standards`
- `install-standards` on `PATH`

If none exists, define `STANDARDS_REPO` in private shell configuration or make
the vendored installer available by syncing from the standards repo:

```bash
$ bin/install-standards <target-repo>
```

Do not fix this by committing a private absolute path into the consumer repo.

### Ignored Vendored Files

If files copy into `vendor/standards/` but do not appear in Git status, check
the consumer repo's ignore rules:

```bash
$ git check-ignore -v vendor/standards/bin/install-standards
```

If a broad ignore rule excludes `vendor/`, add a narrow exception for the
standards files that should be published. Keep the exception scoped to the
vendored standards path instead of unignoring unrelated generated or dependency
content.
