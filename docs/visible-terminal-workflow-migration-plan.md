# Visible Terminal Workflow Migration Plan

## Purpose

This plan records the transition from the legacy copy/paste relay workflow to
the local visible-terminal workflow:

```text
operator <-> ChatGPT conversation <-> named chatgpt tmux shell
                                      -> Codex or Claude when requested
```

It is a planning document. Do not treat it as authority to delete, archive,
rename, or rewrite the listed materials without explicit approval.

## Desired end state

For local repository work, the default initialization is:

1. Start `chatgpt` at the target repository root.
2. Give ChatGPT the resulting named tmux session.
3. Ask ChatGPT to load the standards through that visible shell.
4. Run ordinary shell commands, Codex, or Claude in the same pane as needed.
5. Return to the shell after an agent exits; verify `pwd` and `git status`
   before starting another agent or making a consequential change.

The session name is useful provenance, but the current working directory is
the active repository context. A session name must not be treated as a
repository containment or authorization boundary.

## Preserve before replacing

Keep Git history intact. Prefer deprecation notes, compatibility wrappers, and
an explicit archive directory over deletion.

The following remain useful fallback or specialized materials and should not be
discarded merely because the visible-terminal workflow becomes the local
default:

- `prompts/hitl-review-packet.md`
- `prompts/transcript-handoff.md`
- `load-aider-initialization-prompt.sh`
- the copy/paste-ready sections of specialized audit and remediation prompts

Use clipboard handoffs only when a portable artifact is explicitly requested
or no visible terminal bridge is available.

## Inventory to review

### Initialization surfaces

- `load-standards-initialization-prompt.sh`
- `prompts/project-initialization.md`
- `README.md` project-initialization and AI-handoff sections
- `prompts/README.md` operational-prompt and handoff guidance
- `prompts/universal.md`
- `docs/workflow-architecture.md`

### Legacy copy/paste invocation surfaces

Review every `Invocation instructions` section that says to copy and paste into
Codex, including the repository OPSEC, filename, and script workflow prompts.
The current list includes:

- `prompts/repository-opsec-01-initiate.md`
- `prompts/repository-opsec-02-audit.md`
- `prompts/repository-opsec-03-remediate-text.md`
- `prompts/repository-opsec-04-remediate-media.md`
- `prompts/filename-01-initiate.md`
- `prompts/filename-02-audit.md`
- `prompts/filename-03-remediate.md`
- `prompts/script-01-initiate.md`
- `prompts/script-02-audit.md`
- `prompts/script-03-remediate-headers.md`
- `prompts/script-04-remediate-content.md`

## Proposed migration sequence

### 1. Freeze and classify

Before edits, record the current Git status and classify each affected file as:

- new default workflow guidance
- compatible fallback
- legacy material to archive with a redirect
- historical material preserved by Git history only

Do not mix this inventory with broad wording cleanup.

### 2. Define one canonical local initializer

Create a dedicated prompt, for example:

```text
prompts/tmux-chatgpt-terminal-initialization.md
```

It should instruct a fresh ChatGPT conversation to:

- confirm the named `chatgpt-...` tmux session and current repository
- load `prompts/project-initialization.md` and the relevant standards cascade
- summarize active rules before edits
- use the named pane only when directed by the operator
- keep mutations, commits, pushes, deletion, and publication behind explicit
  operator direction
- re-check `pwd` and `git status` before consequential work or agent launch

### 3. Reframe the existing project initializer

Keep `prompts/project-initialization.md` as the standards-cascade authority.
Make it route local sessions to the new visible-terminal initializer and retain
its current copy/paste block only as a documented fallback.

Do not force a HITL-versus-transcript choice when a visible terminal session is
available. Keep those workflows opt-in.

### 4. Preserve the old loader deliberately

Keep `load-standards-initialization-prompt.sh` as a compatibility loader, with
printing as the default and clipboard copying only through an explicit option.
If its primary purpose becomes legacy support, add a deprecation note and point
to the canonical visible-terminal initializer rather than deleting it.

### 5. Update documentation and specialized prompts

Update the README, prompt index, universal guidance, and workflow architecture
to describe the visible terminal as the local default. Revise specialized
prompt invocation sections to present two paths:

1. instruct ChatGPT to use the named visible session; or
2. use the existing copy/paste block when the session bridge is unavailable.

### 6. Archive only after redirects exist

If a full legacy initialization prompt is superseded, move a snapshot into a
clearly named archive location such as:

```text
docs/archive/legacy-copy-paste-initialization-workflow.md
```

Leave a short redirect at the former entrypoint. Preserve filenames and Git
history until references, loaders, and documentation have been updated and
verified.

### 7. Validate a fresh session

In a disposable repository, verify the documented flow end to end:

1. run `chatgpt` from the repository root
2. load standards from the named session without clipboard transfer
3. run and exit Codex or Claude in the same pane
4. change directories deliberately and confirm that `pwd`, not the session
   name, identifies the active repository
5. verify that the fallback loader still prints and optionally copies its
   legacy prompt

### 8. Review and commit intentionally

Review the migration diff for incorrect claims about security boundaries,
stale copy/paste instructions, and accidental removal of fallback workflows.
Commit only after explicit approval.

## Current implementation note

The visible-terminal workflow document and initial loader/default-guidance
changes may exist as uncommitted work while this plan is being reviewed. Treat
them as a prototype until this migration plan is approved and carried through.
