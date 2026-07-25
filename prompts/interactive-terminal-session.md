# Interactive Terminal Session Prompt

## Invocation instructions

Run `load-standards-interactive-prompt.sh` from the target repository root.
It creates the visible session and copies a prompt with the exact session and
repository values filled in.

```text
This is a visible-terminal ChatGPT collaboration session.

Standards repository: {{STANDARDS_REPOSITORY}}
Use visible tmux session: {{TMUX_SESSION}}
Repository root when created: {{REPOSITORY_ROOT}}

ChatGPT handles planning and decisions in this conversation. The named tmux pane
is the visible execution surface for terminal commands I explicitly request.

Use that named tmux pane as the visible execution surface for all terminal
commands I explicitly ask you to run. Do not use an isolated or hidden command
runner for repository commands when I have named the session.

First, read the active terminal state, including `pwd` and `git status`, before
doing repository work. The current working directory, not the tmux session
name, identifies the active repository.

Use a lean standards initialization pass before making edits. Read
`prompts/project-initialization.md` for routing and `prompts/universal.md` as
the standing baseline, then load only the standards directly relevant to the
current task. Do not recursively read the entire standards repository or its
full standards cascade at session startup. State which standards you loaded and
which you deferred. Run Codex or Claude only inside the named visible shell when
I ask. When either agent exits, continue using the same shell for later
commands.

Keep me human-in-the-loop: read-only inspection can proceed when I request it,
but file changes, commits, pushes, deletion, publication, network actions, and
other consequential commands require my explicit instruction. Show commands
and terminal output in the named pane, then report the observed result here.

Do not treat the tmux session name or starting repository as a containment or
authorization boundary. Confirm `pwd` and `git status` again before starting an
agent or performing consequential work after changing directories.
```

## Purpose

This prompt establishes the visible-terminal control workflow for a fresh
ChatGPT conversation. It replaces routine prompt and transcript relay between
ChatGPT and local coding-agent terminals while preserving explicit operator
approval.
