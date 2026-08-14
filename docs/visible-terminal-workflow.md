# Visible Terminal Workflow

## Purpose

The visible terminal workflow is the default local collaboration model for
AI-assisted repository work when a named, human-visible tmux session is
available. It keeps conversation, decisions, and approval requests visible
to the operator while making requested terminal actions visible in one
named tmux session, regardless of which assistant is driving it.

Two variants are supported, depending on which assistant is holding the
conversation. Both share the same start-a-session step, approval rules,
credential handling, redaction convention, and initialization standards
below. They differ only in who is asking the questions and who is typing
the terminal commands.

## Start a session

From the target repository root, run:

```text
chatgpt
```

Tell the assistant the resulting `shared-llm-<repository-name>-<sequence-number>`
session name. The assistant may use that pane only when the operator
explicitly names it and asks the assistant to use it.

## ChatGPT-orchestrated variant

```text
operator <-> ChatGPT conversation <-> named tmux shell
                                      -> Codex or Claude when requested
```

ChatGPT holds planning and decisions. The shell is persistent. Running
`codex` or `claude` starts the normal CLI in the same visible pane;
exiting it returns to the shell. Do not create a separate agent tmux
session for this workflow.

## Coding-agent-primary variant

```text
operator <-> coding-agent conversation (e.g. Claude Code) <-> named tmux shell
```

A repo-aware coding assistant (Claude Code, Codex, or similar) is itself
the conversation the operator is using, and drives the named pane directly
as its execution surface. No separate ChatGPT layer is involved.

Most tool-calling coding agents do not have a literal attached terminal.
Drive the pane through tmux's own control interface instead of an isolated
command-runner tool:

```text
tmux send-keys -t <session-name> '<command>' Enter
tmux capture-pane -t <session-name> -p
```

`send-keys` injects the command into the visible pane so the operator sees
it appear and run in real time. `capture-pane` reads the result back so the
assistant's next step is informed by what actually happened, not assumed.
This requires the assistant's tool environment to have real shell access to
run `tmux` itself — not every AI tool integration provides this; confirm
before relying on it.

The operator may type directly into the pane at any time, including
outside of anything the assistant asked for (entering a password at a sudo
prompt, running a command themselves). `capture-pane` to read what
happened rather than assuming.

## Approval and review

The named pane is an execution surface, not blanket authority, in either
variant. File changes, commits, pushes, deletion, publication, and other
consequential commands require explicit operator direction. The assistant
must identify the target session and report the observed result in
conversation.

## Credential handling

Never ask the operator to paste a password, secret, or key into the
conversation. When a command needs elevated authentication (for example,
`sudo`), let the command prompt for it in the visible pane and have the
operator type it there directly. The assistant should only ever see the
result of an already-authenticated command, never the credential itself.
This is a real security property of this workflow, not an incidental
convenience, and holds in both variants.

## Redacting sensitive output

When pane output contains a secret, credential, real private IP address,
real phone number, or other identifier that shouldn't be needlessly
duplicated, still confirm what was observed in conversation, but redact
the specific value with a placeholder such as `[redacted]`, `[password]`,
or `[redacted-key]` rather than repeating it verbatim or vaguely dodging
the topic. The operator can already see the real value in the pane; the
assistant's own conversational response doesn't need a second copy of it.

## Initialization standards

For a local visible-terminal session, do not paste the initialization
prompt into Codex or Claude as a standalone copy/paste block. Tell the
assistant to use the named session and load the standards repository
directly. Copy/paste initialization remains a fallback for remote,
disconnected, or standalone coding-agent sessions without a visible pane.

## Legacy handoffs

`prompts/hitl-review-packet.md` and `prompts/transcript-handoff.md` remain
supported specialized workflows for an explicitly requested clipboard artifact
or portable review record. They are no longer the default local context bridge.
