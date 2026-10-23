# Git Repository Backups

A repository with no remote exists in one place. This standard defines how such repositories are backed up: packed by git, encrypted to a public key, copied into a sync folder that already exists, rotated on a schedule, and proven by restoring.

## Purpose

Most repositories are backed up by accident. They have a remote, and the remote is a copy.

Some repositories have no remote on purpose. They hold private records, personal notes, or unpublished work that does not belong on a git host. Others have no remote because nobody got around to it. Either way, one disk failure, one stolen laptop, or one bad `rm` ends them.

This standard covers those repositories. It is written for a single operator on macOS with `launchd`, but every rule except the scheduling section applies to any Unix machine.

## When a repository needs this

A repository needs an encrypted backup when either is true:

- it has no remote
- it has a remote that must not hold its contents, such as a shared or public host

Find candidates with [drydock](https://github.com/yetidevworks/drydock). In the dashboard, sort by visibility (`s` until the sort reads visibility, `S` to reverse it): every repository with no remote lands in one block, separate from private and public ones, with its uncommitted changes in the same row. Those are the first candidates. The same list, as a table:

```text
drydock list --no-remote
```

drydock only sees repositories under the roots in its config, so the search is as complete as those roots. For the second case, a remote that should not hold the contents, turn on drydock's visibility check (`visibility.enabled = true`) and review `drydock list --public` for anything that should never have been pushed there.

Before adding a repository, read its `AGENTS.md` or README for rules about where its contents may go. An encrypted copy is still a copy. If the repository forbids off-machine copies, record an explicit exception in that repository before backing it up.

Keep the list of backed-up repositories in a plain local file, one path per line. The list is configuration, not code, and it reveals what exists. It does not belong in a public repository.

Include remote-less repositories that are still empty. The job skips them until they have content, and then they are covered from the first night instead of from whenever someone remembers.

### Coverage check

New remote-less repositories appear without announcement. Compare drydock's view against the list periodically:

```text
drydock list --no-remote --json | jq -r '.[].path' | sort > /tmp/remoteless
sed -E 's/[[:space:]]+include-ignored[[:space:]]*$//; s#^~#'"$HOME"'#' <list> \
  | grep -vE '^[[:space:]]*(#|$)' | sort > /tmp/listed
comm -23 /tmp/remoteless /tmp/listed     # remote-less but not backed up
comm -13 /tmp/remoteless /tmp/listed     # backed up but now has a remote
```

The second list is not necessarily wrong. A repository that gained a remote may still need encrypted backups if the remote must not hold everything. Decide, and record the decision next to the entry.

## What a backup contains

### Repositories with commits

Use a git bundle of every ref:

```text
git bundle create <file> --all
git bundle verify <file>
```

`--all` includes every branch, tag, and stash. A bundle is a single file, verifiable on its own, and restorable with `git clone`.

A bundle does not include unstaged changes, untracked files, or ignored files. See [Uncommitted work](#uncommitted-work).

### Repositories with no commits

A repository with no commits has nothing to bundle. Back up its working tree as a compressed tar, built through git with a throwaway git directory:

```text
tmp_git=$(mktemp -d)
git --git-dir="$tmp_git" init -q --bare
git --git-dir="$tmp_git" --work-tree=<repo> add -A
tree=$(git --git-dir="$tmp_git" --work-tree=<repo> write-tree)
git --git-dir="$tmp_git" archive --format=tar.gz --prefix=<name>/ -o <file> "$tree"
rm -rf "$tmp_git"
```

This does three things a plain `tar` does not:

- it honors `.gitignore`, so build output and caches stay out
- it never touches the repository's own index or `.git` directory
- every read goes through git, which matters on macOS (see [Scheduling on macOS](#scheduling-on-macos))

Empty directories are not included. The tree hash doubles as the change fingerprint.

### Ignored files that hold real data

Some repositories keep real data in ignored files: save files, a local database, generated assets that took hours to produce. A bundle and the tar above both skip them.

Back these up only when a repository is explicitly flagged for it, as a separate archive with its own rotation:

```text
git -C <repo> ls-files -z -o -i --exclude-standard
```

Feed that list (minus `.DS_Store`) into a throwaway git directory with `git add -f --pathspec-from-file=- --pathspec-file-nul`, then archive it as above with the same `--prefix` as the main archive, so both unpack into the same folder.

Do not flag a repository by default. Ignored files are often large, regenerable, or secret. An `.env` file is ignored for a reason.

### Read only

The job reads repositories; it never writes to them. Bundling, `for-each-ref`, and `ls-files` do not modify a repository, and the throwaway git directory keeps the tar path's index out of it. Set `GIT_OPTIONAL_LOCKS=0` in the job's environment anyway, so no git command it runs can take `index.lock` or refresh an index while an editor or git client has the repository open at the same moment.

## Encryption

Encrypt every backup with [age](https://age-encryption.org) to a public key.

- Generate a post-quantum hybrid key: `age-keygen -pq -o <keyfile>` (age 1.3 or later).
- Extract the public key with `age-keygen -y <keyfile>` and keep only that on the machine, in a recipients file.
- Store the private key in a password manager, plus one offline copy (printed, or on media kept away from the machine). Then delete the key file.
- The backup job refuses to run if its recipients file contains `AGE-SECRET-KEY`.

The machine that makes backups cannot read them. That is the point: a compromised or stolen machine yields encrypted files and a public key.

There is no plain-text mode. Not for testing, not for speed, not behind a flag. A flag exists to be turned on.

Losing the private key makes every backup unreadable. Test that the stored copy decrypts before relying on it.

## Storage

Copy encrypted backups into a sync folder that is already trusted with comparable data: the cloud storage folder the operator already uses for documents.

Do not sign up for a new service to hold backups. A new service is a new account, a new credential, a new trust decision, and a new place to forget about. Encryption makes the storage provider's confidentiality irrelevant; what matters is that the folder is already maintained, already synced off the machine, and already watched.

Use one dedicated subfolder. Write only `.age` files into it.

## Naming, change detection, and rotation

### Timestamped names

Name each backup `<repo>-YYYY-MM-DD-HHMM.<kind>.age`, where `<kind>` is `bundle`, `tar.gz`, or, for ignored files, a separate `<repo>-ignored-...tar.gz` name. Never overwrite a previous backup. Each run writes a new file; rotation removes old ones.

### Skip unchanged repositories

Fingerprint each repository before backing it up and skip it if the fingerprint matches the last successful backup:

- repositories with commits: a hash of `git for-each-ref --format='%(objectname) %(refname)'`
- repositories with no commits, and ignored files: the git tree hash from the throwaway directory

Store the fingerprint only after the encrypted file has been written and verified.

Also store a hash of the recipients file. When the key changes, clear every fingerprint so the next run re-encrypts all repositories to the new key. Otherwise unchanged repositories stay encrypted to the old key indefinitely.

### Rotation

For each repository, keep:

- the newest backup, always
- the newest backup of each of the last 7 days
- the newest backup of each of the last 4 weeks
- the newest backup of each of the last 12 months

Everything else is deleted. That is at most about 23 files per repository.

The first rule is not optional. Skipping unchanged repositories means an untouched repository's last backup may be its only backup. Without "always keep the newest", age-based rotation deletes it after a year and nothing replaces it.

Rotate from a local list of the backups the job has written, not by listing the storage folder (see below). The list must tolerate duplicate entries without treating a file as an older copy of itself. Compute day boundaries at noon, not midnight, so a daylight saving change cannot shift a backup into the wrong day.

A failed deletion is logged, kept on the list, and retried on the next run. Never delete backups by hand as routine; rotation is the only routine deletion.

## Scheduling on macOS

Run the job nightly with a per-user `launchd` agent (`~/Library/LaunchAgents/<label>.plist`, `StartCalendarInterval`). If the machine is asleep at the scheduled time, `launchd` runs the job on wake. If it is shut down, that night is skipped.

Install the job by copying the script, the repository list, and the recipients file to a location outside protected folders (for example `~/.local/share/<tool>`), and point the plist there. Re-run the install after any change; the job runs the copy, not the working checkout.

### Background job limits

A `launchd` job does not have the permissions of a Terminal session. These limits were observed on macOS 27 in October 2026; they may change between releases.

Protected user folders (Documents, Desktop, Downloads):

- The job's shell, `find`, and `tar` cannot read files there.
- `git` can. Every read of a repository therefore goes through git: bundle, `for-each-ref`, `ls-files`, and the throwaway-directory `add`.
- The job's own script and configuration should not live there either, since the job reads them with ordinary tools. Install them elsewhere.

Cloud storage folders managed by a File Provider extension (under `~/Library/CloudStorage`):

- **Cannot rename** inside the folder. Encrypt to a local temporary file, `cp` it in, then `cmp` the copy against the original.
- **Cannot replace a file another process created.** Timestamped names mean the job never needs to.
- **Cannot list** the folder. It reads as empty. Keep a local list of written backups per repository and rotate from it, deleting by name.
- **Can** create files, copy, compare, `stat`, and delete files it wrote itself, including files written before a reinstall. Deleting files left over from setup-time runs was observed to fail; log the failure and retry next run rather than abort.

Every one of these operations works when the same script is run by hand from Terminal. A manual run proves nothing about the nightly run.

### Test through launchd

After any change:

1. Run the script by hand against throwaway paths and a throwaway key (see [Verification](#verification)).
2. Install it.
3. Run the installed job through `launchd`:

```text
launchctl kickstart gui/$(id -u)/<label>
```

4. Read the log.

## Failure visibility

A backup that fails silently is worse than no backup, because it is trusted.

- Log every run to a local file: a start line, one line per repository, and a final count of failures. Rotate the log by size.
- Continue past a failing repository; one bad repository must not stop the others.
- Show a desktop notification when any repository fails or the run aborts (`osascript -e 'display notification ...'` works from a user agent).
- Write a last-run file with a timestamp and failure count, and provide a status command that exits non-zero if the last run is older than 36 hours or had failures.
- Take a lock at start so a manual `kickstart` cannot overlap the scheduled run. Store the holder's process ID and clear a lock whose process no longer exists, or a crash blocks every later run.

A healthy log shows, for each repository, either a written file with its size or `unchanged, skipped`, possibly followed by rotation lines, and ends with zero failures:

```text
=== 2026-01-14 02:30:01 start
<repo-a>: wrote <repo-a>-2026-01-14-0230.bundle.age (253678 bytes)
<repo-a>: rotated out <repo-a>-2026-01-13-0230.bundle.age
<repo-b>: unchanged, skipped
=== done (0 failed)
```

## Verification

A backup is a claim until a restore proves it.

Test with a throwaway key so the real private key never touches disk:

```text
umask 077
age-keygen -pq -o /tmp/t/k.txt
age-keygen -y /tmp/t/k.txt > /tmp/t/recipients.txt
```

Point the job at throwaway destination, state, and list paths, run it, restore every kind of backup it produced, and delete the throwaway key afterward. Test at least:

- a bundle with more than one branch, a tag, and a stash
- a tar from a repository with no commits
- an ignored-files archive unpacked over its tar
- a second run that skips everything as unchanged
- a key change that re-encrypts everything
- rotation over a simulated year of nightly backups, including a repository whose only backup is more than a year old
- a failing repository, which must produce a failure count, a notification, and a non-zero status

Then restore one real backup with the real key, from the storage provider rather than the local machine, at least once after setup and after any change to the format.

## Restore

Put the private key in a private temporary file and delete it when done:

```text
umask 077; k=$(mktemp); pbpaste > "$k"
```

A bundle:

```text
age -d -i "$k" <repo>-<stamp>.bundle.age > <repo>.bundle
git clone <repo>.bundle <repo> && cd <repo>
git fetch --update-head-ok ../<repo>.bundle 'refs/*:refs/*'
git remote remove origin
git fsck
```

`git clone` alone checks out the default branch and leaves the rest as remote-tracking refs. The fetch restores every branch, tag, and stash as local refs.

A tar, then its ignored files if any:

```text
age -d -i "$k" <repo>-<stamp>.tar.gz.age | tar xzf -
age -d -i "$k" <repo>-ignored-<stamp>.tar.gz.age | tar xzf -
```

The tar has no `.git`; run `git init` to start again.

Finally:

```text
rm -f "$k"
```

## Uncommitted work

Bundles back up commits. Unstaged changes and untracked files are not backed up for any repository that has a commit.

Commit before you stop for the day. If the work is not ready to commit, `git stash -u` puts it into a ref that the next bundle includes.

drydock lists exactly the repositories whose work tonight's backup would miss:

```text
drydock list --no-remote --dirty --match-mode all
```

For a repository with commits, every unstaged (`~`) or untracked (`?`) count in that list is work that exists only on this disk. For a repository with no commits yet (branch `(unborn)`), untracked files are covered by the tar; only ignored files are not.

Stashes appear in drydock's stash count and in the bundle. They are backed up, but they are easy to forget; restore brings them back as `refs/stash`, not as files.

## Operator checklist

- [ ] Candidates found with `drydock list --no-remote`; each repository's own rules read
- [ ] Coverage check run; empty remote-less repositories included
- [ ] `drydock list --no-remote --dirty --match-mode all` reviewed; work committed or stashed
- [ ] Post-quantum age key generated; private key in a password manager and one offline copy; no key file left on disk
- [ ] Only the public key on the machine; the job refuses a private key
- [ ] Encrypted files written to one subfolder of an existing sync folder
- [ ] Timestamped names; unchanged repositories skipped; key change re-encrypts
- [ ] Rotation keeps the newest always, plus 7 daily, 4 weekly, 12 monthly
- [ ] Job installed outside protected folders and scheduled with `launchd`
- [ ] Tested with a throwaway key, then through `launchctl kickstart`
- [ ] Failures notify; status command reports the last run
- [ ] One real restore done with the real key, from the storage provider

## Related standards

- [Operator principles](operator-principles.md)
- [OPSEC as systems thinking](../opsec-as-systems-thinking.md)
- [Operational audits](operational-audits.md)
