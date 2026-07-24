# Visible Terminal Workflow

## Purpose

The visible terminal workflow is the default local collaboration model for
ChatGPT-assisted repository work. It keeps conversation, decisions, and
approval requests in ChatGPT while making requested terminal actions visible in
one named tmux session.

## Start a session

From the target repository root, run:

```text
chatgpt
```

Tell ChatGPT the resulting `chatgpt-<repository-name>-<sequence-number>`
session name. ChatGPT may use that pane only when the operator explicitly asks.

## Working model

```text
operator <-> ChatGPT conversation <-> named tmux shell
                                      -> Codex or Claude when requested
```

The shell is persistent. Running `codex` or `claude` starts the normal CLI in
the same visible pane; exiting it returns to the shell. Do not create a
separate agent tmux session for this workflow.

## Approval and review

The named pane is an execution surface, not blanket authority. File changes,
commits, pushes, deletion, publication, and other consequential commands
require explicit operator direction. ChatGPT must identify the target session
and report the observed result in conversation.

## Initialization standards

For a local visible-terminal session, do not paste the initialization prompt
into Codex or Claude. Tell ChatGPT to use the named session and load the
standards repository. Copy/paste initialization remains a fallback for remote,
disconnected, or standalone coding-agent sessions.

## Legacy handoffs

`prompts/hitl-review-packet.md` and `prompts/transcript-handoff.md` remain
supported specialized workflows for an explicitly requested clipboard artifact
or portable review record. They are no longer the default local context bridge.
