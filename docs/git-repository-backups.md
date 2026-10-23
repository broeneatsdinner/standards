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

Back up everything in the repository folder. `.gitignore` decides what goes into version control and what gets shared; it does not decide what is worth keeping. In a private repository, ignored files are often the most valuable thing in it: a `private/` folder of notes, images, or recordings, save files, a local database, personal data that must never be committed. Encryption removes the reason to leave them behind.

Each repository gets up to two files per run: a bundle for history, and a files archive for everything else.

### The bundle: history

Use a git bundle of every ref:

```text
git bundle create <file> --all
git bundle verify <file>
```

`--all` includes every branch, tag, and stash. A bundle is a single file, verifiable on its own, and restorable with `git clone`.

A bundle does not include unstaged changes, untracked files, or ignored files. The files archive holds those. A repository with no commits has no bundle.

### The files archive: everything else

The files archive holds everything on disk that the bundle does not:

- untracked files
- ignored files
- tracked files that are changed or staged
- a list of tracked files deleted from disk

For a repository with no commits, that is the whole working tree. Unpacked over a clone of the bundle, it gives back the folder as it was, uncommitted work included.

Build it through git with a throwaway git directory. Every read then goes through git, which matters on macOS (see [Scheduling on macOS](#scheduling-on-macos)), and the repository's own index is never touched:

```text
tmp_git=$(mktemp -d)
git --git-dir="$tmp_git" init -q --bare
git --git-dir="$tmp_git" --work-tree=<repo> add -A -f -- . <exclude pathspecs>
```

`-f` includes ignored files. Compare the snapshot with `HEAD`: `git ls-files -s` in the throwaway directory against `git ls-tree -r HEAD` in the repository. Keep the entries that are new or whose mode or blob differ, write them into a second index with `git update-index --index-info`, add a blob listing the tracked paths missing from the snapshot, and archive that tree with `git archive --prefix=<name>/`. Use NUL-separated output (`-z`) throughout; git quotes unusual filenames otherwise, and quoted names slip past pattern matching.

### Exclusions

Leave out only what can be rebuilt without the backup, and clutter:

- dependencies and virtual environments a package manager restores: `node_modules`, `.venv`, `venv`
- Python byproducts: `__pycache__`, `*.pyc`, `*.egg-info`, test and type-checker caches
- tool caches
- macOS files: `.DS_Store`, `._*`

Keep the list in one file, one glob per line, and pass each as a pathspec: `:(exclude,glob)**/node_modules/**`. Do not exclude by `.gitignore`. The list also keeps the archive stable: caches change whenever code runs, and without the list most repositories would look changed every night.

Two things git cannot capture: empty directories, and nested repositories inside the folder. git refuses to add a nested repository that has no commits, which fails the whole snapshot, so find nested repositories first (`git ls-files -o` lists them with a trailing `/`), exclude them, and log each one. A nested repository needs its own entry in the backup list.

Ignored files include secrets such as `.env` files. They leave the machine encrypted to a key the machine cannot use, which is the threat model this standard accepts. If a repository's own rules forbid its files leaving the machine in any form, record an exception there before backing it up.

### Read only

The job reads repositories; it never writes to them. Bundling, `for-each-ref`, `ls-files`, and `ls-tree` do not modify a repository, and the throwaway git directory keeps the snapshot's index out of it. Set `GIT_OPTIONAL_LOCKS=0` in the job's environment anyway, so no git command it runs can take `index.lock` or refresh an index while an editor or git client has the repository open at the same moment.

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

Name bundles `<repo>-YYYY-MM-DD-HHMM.bundle.age` and files archives `<repo>-files-YYYY-MM-DD-HHMM.tar.gz.age`. Never overwrite a previous backup. Each run writes a new file; rotation removes old ones.

### Skip unchanged repositories

Fingerprint each repository before backing it up and skip it if the fingerprint matches the last successful backup:

- bundle: a hash of `git for-each-ref --format='%(objectname) %(refname)'`
- files archive: the hash of the archived tree, plus the bundle's refs hash

Including the refs hash means a new bundle always comes with a files archive from the same run, so the newest of each always belong together. When a repository that has had extras becomes clean, write an empty files archive rather than nothing; otherwise the newest files archive is stale and a restore would bring back files that were since committed or deleted. A repository that has never had extras needs no files archive.

Store the fingerprint only after the encrypted file has been written and verified.

Also store a hash of the recipients file. When the key changes, clear every fingerprint so the next run re-encrypts all repositories to the new key. Otherwise unchanged repositories stay encrypted to the old key indefinitely.

### Rotation

For each repository, and separately for bundles and files archives, keep:

- the newest backup, always
- the newest backup of each of the last 7 days
- the newest backup of each of the last 4 weeks
- the newest backup of each of the last 12 months

Everything else is deleted. That is at most about 23 of each per repository.

The first rule is not optional. Skipping unchanged repositories means an untouched repository's last backup may be its only backup. Without "always keep the newest", age-based rotation deletes it after a year and nothing replaces it.

Rotate from a local list of the backups the job has written, not by listing the storage folder (see below). The list must tolerate duplicate entries without treating a file as an older copy of itself. Compute day boundaries at noon, not midnight, so a daylight saving change cannot shift a backup into the wrong day.

A failed deletion is logged, kept on the list, and retried on the next run. Never delete backups by hand as routine; rotation is the only routine deletion.

When the format changes and a kind of backup is no longer written, keep rotating its list under the same rules but without "always keep the newest", so the old files age out instead of one lingering forever.

Files archives grow with what lives outside git. A large file there, such as a recording in a `private/` folder, is uploaded again whenever the repository changes, and kept under the rules above. Watch the archive sizes in the log; a repository that gains gigabytes of media may need its media split into an archive of its own.

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
- a files archive holding ignored, untracked, staged, modified, deleted, and non-ASCII-named files, restored over its bundle and compared file by file with the original folder
- a repository with no commits, restored from its files archive alone
- a second run that skips everything as unchanged
- a change only inside an excluded cache, which must not trigger a backup
- a commit, which must write a bundle and a files archive in the same run
- a repository that becomes clean, which must get an empty files archive
- a nested repository with no commits, which must be logged without failing its parent
- a key change that re-encrypts everything
- rotation over a simulated year of nightly backups, including a repository whose only backup is more than a year old
- a failing repository, which must produce a failure count, a notification, and a non-zero status

Then restore one real backup with the real key, from the storage provider rather than the local machine, at least once after setup and after any change to the format.

## Restore

Put the private key in a private temporary file and delete it when done:

```text
umask 077; k=$(mktemp); pbpaste > "$k"
```

Take the newest bundle and the newest files archive. The files archive's stamp should be the same as the bundle's or later; if it is earlier, a files backup failed after that bundle, so skip it. For an older point in time, take a bundle and the files archive with the same stamp or the first one after it.

The bundle:

```text
age -d -i "$k" <repo>-<stamp>.bundle.age > <repo>.bundle
git clone <repo>.bundle <repo> && cd <repo>
git fetch --update-head-ok ../<repo>.bundle 'refs/*:refs/*'
git remote remove origin
git fsck
cd ..
```

`git clone` alone checks out the default branch and leaves the rest as remote-tracking refs. The fetch restores every branch, tag, and stash as local refs.

The files archive, unpacked over it, then the deletions it records:

```text
age -d -i "$k" <repo>-files-<stamp>.tar.gz.age | tar xzf -
cd <repo>
tr '\n' '\0' < .git-backup-deleted | xargs -0 rm -f --; rm .git-backup-deleted
```

Skip the last line when the archive has no deletion list. A repository with no commits has only the files archive; it unpacks with no `.git`, so run `git init` to start again.

Finally:

```text
rm -f "$k"
```

## Uncommitted work

The files archive backs up uncommitted work, but only as it stood at the last run, and only the newest state of each day survives rotation past a week. A commit is still the better record: it has a message, it survives every later edit, and it is in history.

drydock lists the repositories with work that exists only as uncommitted files:

```text
drydock list --no-remote --dirty --match-mode all
```

Review it regularly, and commit what is real. Work that is not ready to commit can go into `git stash -u`, which puts it into a ref the bundle includes; restore brings it back as `refs/stash`, not as files.

## Operator checklist

- [ ] Candidates found with `drydock list --no-remote`; each repository's own rules read
- [ ] Coverage check run; empty remote-less repositories included
- [ ] `drydock list --no-remote --dirty --match-mode all` reviewed; work committed or stashed
- [ ] Post-quantum age key generated; private key in a password manager and one offline copy; no key file left on disk
- [ ] Only the public key on the machine; the job refuses a private key
- [ ] Encrypted files written to one subfolder of an existing sync folder
- [ ] Bundle plus files archive per repository; ignored files included; only rebuildable output and clutter excluded
- [ ] Nested repositories logged, and listed for backup in their own right
- [ ] Timestamped names; unchanged repositories skipped; key change re-encrypts
- [ ] Rotation keeps the newest always, plus 7 daily, 4 weekly, 12 monthly, for each kind
- [ ] Job installed outside protected folders and scheduled with `launchd`
- [ ] Tested with a throwaway key, then through `launchctl kickstart`
- [ ] Failures notify; status command reports the last run
- [ ] One real restore done with the real key, from the storage provider

## Related standards

- [Operator principles](operator-principles.md)
- [OPSEC as systems thinking](../opsec-as-systems-thinking.md)
- [Operational audits](operational-audits.md)
