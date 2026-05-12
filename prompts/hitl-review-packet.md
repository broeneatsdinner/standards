# HITL Review Packet Prompt

## Invocation instructions

Use this prompt when a Codex or AI coding session should prepare clipboard-based human-in-the-loop review packets before commit decisions.

Copy/paste instruction:

	Apply the loaded project standards.
	Load prompts/hitl-review-packet.md.
	Use the HITL review packet workflow before commit decisions in this session.
	Do not commit until I review the packet and explicitly approve the commit.

## Purpose

This prompt defines a human-in-the-loop review packet workflow for Codex and other repository-aware AI coding tools.

Use this workflow when an AI coding tool has made file changes but should not commit yet.

The goal is to make review fast, complete, and copy/paste-safe:

```text
AI edits.
AI validates.
AI gathers status, diff, and checks.
AI copies a review packet to the clipboard.
Human pastes the packet into ChatGPT or another review channel.
Human and reviewer inspect the same evidence.
Human decides whether to commit, revise, or discard.
```

## When to use

Use this workflow after tasks that modify:

- source code
- documentation
- prompts
- tests
- repository structure
- configuration
- scripts
- generated project files that are intended to be committed

Use it especially when:

- the user wants to review before commit
- a task involves privacy, OPSEC, or publication hygiene
- a task affects app behavior
- a task affects build or signing configuration
- a task creates a large diff
- the user is coordinating review with ChatGPT

## Relationship to project initialization

This is a specialized workflow prompt.

Do not load it during every session by default.

Load it when the user asks for a review packet, clipboard handoff, human-in-the-loop review, HITL workflow, or pre-commit review bundle.

## Required packet contents

A review packet should include:

- concise summary of what changed
- validation commands run and whether they passed or failed
- relevant grep, privacy, or OPSEC checks
- git status using pager-safe output
- diff stat using pager-safe output
- relevant diff output using pager-safe output
- suggested commit message
- explicit note that no commit was made unless the user requested one
- final human-facing review note or wrap-up that the AI would normally show in chat

Do not include:

- generated build logs unless a failure needs review
- full DerivedData output
- ignored private files
- secrets, tokens, private paths, private screenshots, or private health data
- noisy unrelated diffs
- pager output
- duplicate full diffs in both the structured evidence and the final review note

## Clipboard behavior

Copy the review packet to the clipboard with pbcopy.

Prefer writing the review packet to a stable temporary file first, then copying from that file with a short pbcopy command:

```bash
packet_file="/tmp/hitl-review-packet.txt"

cat > "$packet_file" <<'EOF'
<review packet content>
EOF

pbcopy < "$packet_file"
```

This has two advantages:

- if clipboard approval fails or is interrupted, the review packet still exists on disk
- the clipboard command remains short, stable, and clearly scoped to the HITL packet handoff

Prefer this over piping a generated command group into pbcopy, because some approval systems evaluate the whole generated command rather than only the final `pbcopy` process.

When appropriate in the user's environment, an existing helper such as catcopy may also be used, but pbcopy is the portable macOS default.

If the environment asks for command approval before running pbcopy, treat approval as a narrow clipboard-handoff approval for the HITL review packet only.

When the session preference is set to always approve pbcopy for HITL review packets, do not ask the user in chat whether pbcopy should be approved. Proceed with the environment's approval flow if required.

This approval does not apply to unrelated commands, shell actions, file writes, network access, destructive actions, or arbitrary clipboard use.

After copying the packet, tell the user:

```text
Review packet copied to clipboard.
```

## Review packet template

Use this pattern and adjust the changed paths and checks to match the task:

```bash
{
	printf '%s\n' 'Review packet'
	printf '%s\n' '============='
	printf '\n'

	printf '%s\n' 'Summary'
	printf '%s\n' '-------'
	printf '%s\n' '<write concise task summary here>'
	printf '\n'

	printf '%s\n' 'Validation'
	printf '%s\n' '----------'
	printf '%s\n' '<list validation commands and pass/fail results here>'
	printf '\n'

	printf '%s\n' 'Checks'
	printf '%s\n' '------'
	printf '%s\n' '<list grep/privacy/OPSEC checks and results here>'
	printf '\n'

	printf '%s\n' 'Git status'
	printf '%s\n' '----------'
	git --no-pager status --short
	printf '\n'

	printf '%s\n' 'Diff stat'
	printf '%s\n' '---------'
	git --no-pager diff --stat
	printf '\n'

	printf '%s\n' 'Relevant diff'
	printf '%s\n' '-------------'
	git --no-pager diff -- README.md docs prompts shell scripts bin examples tests
	printf '\n'

	printf '%s\n' 'Suggested commit'
	printf '%s\n' '----------------'
	printf '%s\n' '<suggested commit message>'
	printf '\n'

	printf '%s\n' 'AI review note'
	printf '%s\n' '--------------'
	printf '%s\n' '<include the final human-facing review note or wrap-up here>'
	printf '\n'

	printf '%s\n' 'Commit status'
	printf '%s\n' '-------------'
	printf '%s\n' 'No commit was made.'
} | pbcopy
```

## Source-code project example

For source-code projects, include application source paths and project files as needed:

```bash
{
	printf '%s\n' 'Review packet'
	printf '%s\n' '============='
	printf '\n'

	printf '%s\n' 'Summary'
	printf '%s\n' '-------'
	printf '%s\n' '<write concise task summary here>'
	printf '\n'

	printf '%s\n' 'Validation'
	printf '%s\n' '----------'
	printf '%s\n' '<example: xcodebuild simulator build passed>'
	printf '\n'

	printf '%s\n' 'Checks'
	printf '%s\n' '------'
	printf '%s\n' '<example: privacy grep found no real medication names or private screenshots>'
	printf '\n'

	printf '%s\n' 'Git status'
	printf '%s\n' '----------'
	git --no-pager status --short
	printf '\n'

	printf '%s\n' 'Diff stat'
	printf '%s\n' '---------'
	git --no-pager diff --stat
	printf '\n'

	printf '%s\n' 'Relevant diff'
	printf '%s\n' '-------------'
	git --no-pager diff -- README.md docs prompts MedicationReminder MedicationReminder.xcodeproj
	printf '\n'

	printf '%s\n' 'Suggested commit'
	printf '%s\n' '----------------'
	printf '%s\n' '<suggested commit message>'
	printf '\n'

	printf '%s\n' 'AI review note'
	printf '%s\n' '--------------'
	printf '%s\n' '<include the final human-facing review note or wrap-up here>'
	printf '\n'

	printf '%s\n' 'Commit status'
	printf '%s\n' '-------------'
	printf '%s\n' 'No commit was made.'
} | pbcopy
```

## Final review note

At the end of the packet, include the final human-facing review note or wrap-up that the AI would normally show in chat.

The AI review note should be the same final natural-language response that the AI prints to the user after preparing the packet. Do not create a separate paraphrase for the clipboard packet and a different final response for chat.

A good workflow is:

1. Compose the final human-facing review note.
2. Include that exact note in the packet under `AI review note`.
3. Copy the packet to the clipboard.
4. Print the same final note in chat, followed by any required session-preference reminder.

This note should preserve the AI's concise judgment, findings, recommendation, and next-step guidance.

It should not duplicate the full diff or large logs already included elsewhere in the packet.

For example, the note may include:

- whether findings are blockers or non-blockers
- whether remaining issues are acceptable for the stated scope
- whether validation passed
- whether the review packet was copied
- whether a commit was intentionally not made
- the current session-preference reminder when applicable

The review packet should therefore contain both structured evidence and the AI's final interpretation of that evidence.

## Failure behavior

If validation fails, the packet should include:

- failing command
- concise failure summary
- relevant error excerpt
- current pager-safe git status
- relevant diff

Do not paste the entire build log unless the user asks for it.

For long build failures, include the smallest useful excerpt.

## Review discipline

The AI tool should not commit after preparing the packet unless the user explicitly asks it to commit.

The packet is an evidence bundle for human review, not approval to proceed.

The human decides the next action.
