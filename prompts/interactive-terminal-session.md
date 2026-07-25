# Interactive Terminal Session Prompt

## Invocation instructions

Run `load-standards-interactive-prompt.sh`, then paste the copied text into a
new ChatGPT conversation after starting `chatgpt` in the target repository.

```text
Apply the interactive terminal session standard for this conversation.

I have started a named `chatgpt-...` tmux session in a target repository. Use
that named tmux pane as the visible execution surface for all terminal commands
I explicitly ask you to run. Do not use an isolated or hidden command runner
for repository commands when I have named the session.

First, ask me for the exact tmux session name if I have not supplied it. Then
read the active terminal state, including `pwd` and `git status`, before doing
repository work. The current working directory, not the tmux session name,
identifies the active repository.

Load the applicable standards from the local standards repository and summarize
the active rules before making edits. Run Codex or Claude only inside the named
visible shell when I ask. When either agent exits, continue using the same shell
for later commands.

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
