# Transcript Handoff Prompt

## Invocation instructions

Use this prompt when a Codex or AI coding session should prepare a lightweight
clipboard transcript for routine handoff to ChatGPT or another review channel.

Copy/paste instruction:

	Apply the loaded project standards.
	Load prompts/transcript-handoff.md.
	Use the transcript handoff workflow for this session.
	When I ask for a handoff, copy the most recent operator prompt and the terminal-visible assistant output produced after that prompt verbatim.

## Purpose

This prompt defines a lightweight transcript handoff workflow for routine
Codex work.

Use this workflow when the operator wants to paste the latest prompt and the
terminal-visible assistant output into ChatGPT without generating a full
structured HITL review packet.

Transcript handoff is for quick context transfer. It is not a substitute for
the full HITL review packet workflow when the operator needs structured
validation evidence, git status, diff stats, relevant diffs, suggested commit
messages, or pre-commit review discipline.

## Relationship to HITL review packets

Transcript handoff and HITL review packets are separate workflows.

Use `prompts/hitl-review-packet.md` when the operator wants a structured
pre-commit evidence bundle after file changes.

Use `prompts/transcript-handoff.md` when the operator only wants the most
recent operator prompt and the terminal-visible assistant output from that
prompt copied exactly for routine iterative review.

Do not combine the formats unless the operator explicitly asks for both.

## Required handoff contents

A transcript handoff MUST contain exactly:

1. the most recent operator prompt, verbatim
2. the terminal-visible assistant output produced after that prompt, verbatim

The handoff MUST preserve visible formatting exactly.

This includes:

- headings
- bullets
- numbered lists
- blank lines
- indentation
- code-like blocks
- command output
- visible status lines
- visible validation summaries
- visible caveats
- visible session-preference reminders

The handoff MUST NOT:

- summarize
- paraphrase
- restructure
- relabel
- normalize prose
- collapse bullets or numbered lists into paragraphs
- remove headings
- remove blank lines
- remove indentation
- add review-packet sections
- add an AI review note
- add validation, checks, git status, diff stat, relevant diff, suggested
  commit, final-response, or commit-status headings unless those headings were
  already part of the terminal-visible assistant output

The only acceptable transformation is stripping ANSI or other control
sequences when necessary for safe clipboard transport. Otherwise, the handoff
content must remain exact.

## Clipboard behavior

Copy the transcript handoff to the clipboard with pbcopy.

Prefer writing the transcript handoff to a stable temporary file first, then
copying from that file with a short pbcopy command:

```bash
handoff_file="/tmp/transcript-handoff.txt"

cat > "$handoff_file" <<'EOF'
<most recent operator prompt, verbatim>

<terminal-visible assistant output produced after that prompt, verbatim>
EOF

pbcopy < "$handoff_file"
```

If the environment asks for command approval before running pbcopy, treat
approval as a narrow clipboard-handoff approval for the transcript handoff
only.

This approval does not apply to unrelated commands, shell actions, file writes,
network access, destructive actions, or arbitrary clipboard use.

After copying the handoff, tell the user:

```text
Transcript handoff copied to clipboard.
```

## Failure behavior

If the tool cannot access the exact most recent operator prompt or the exact
terminal-visible assistant output produced after that prompt, it MUST say so
instead of reconstructing, summarizing, or approximating the handoff.

If exact capture is unavailable, ask the operator to provide the missing text
or use another review workflow.

## Review discipline

The transcript handoff is a context-transfer artifact, not a structured review
packet.

It does not imply that validation was run, a diff was checked, or a commit is
approved.

The AI tool should not commit after preparing a transcript handoff unless the
operator explicitly asks it to commit.
