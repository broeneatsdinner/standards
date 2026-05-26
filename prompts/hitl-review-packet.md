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

## Required packet format

Use the following packet headings exactly, in this order, unless the user explicitly asks for a different packet format:

```text
Review packet
=============

Summary
-------

Validation
----------

Checks
------

Git status
----------

Diff stat
---------

Relevant diff
-------------

Suggested commit
----------------

Final operator-visible response
-------------------------------

Commit status
-------------
```

Do not rename these headings to alternatives such as `HITL Review Packet`,
`Task`, `Files Changed`, `Pager-Safe Status`, `Suggested Commit Message`, or
older note-style headings.

Additional sections may be added only when they materially improve review, but the required headings and order should remain stable.

## Final response payload rule

The `Final operator-visible response` section content is a payload, not a note
to be rewritten.

The final-response payload MUST be the exact final operator-visible assistant
response text that the AI will print in chat after copying the packet.

Use the operator-visible final response, not an internal summary, separate
note, tool summary, or alternate representation.

Do not prepend old note-style labels inside the payload.

Do not paraphrase, summarize, normalize prose, collapse bulleted or numbered
lists into paragraphs, remove or rewrite section headers, remove blank lines,
change indentation, remove validation blocks, remove fenced or code-like
blocks, remove footer lines, or otherwise change visible structure.

If the final operator-visible response includes the required
`Review packet copied to clipboard.` status line, a validation summary, caveats,
next steps, bulleted lists, numbered lists, indented blocks, fenced or
code-like blocks, or a session-preference reminder, include those lines and
their visible structure in the payload exactly as they will appear in chat.

Preserve line breaks and formatting exactly.

The only acceptable transformation is stripping ANSI or other control
sequences when necessary for safe clipboard transport. Otherwise, the text must
remain exact.

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
- verbatim final operator-visible assistant response that the AI prints in chat

Do not include:

- generated build logs unless a failure needs review
- full DerivedData output
- ignored private files
- secrets, tokens, private paths, private screenshots, or private health data
- noisy unrelated diffs
- pager output
- duplicate full diffs in both the structured evidence and the final
  operator-visible response

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

If that status line is part of the final operator-visible response, it must
also be present in the `Final operator-visible response` payload in the review
packet.

## Review packet template

Use this pattern and adjust the changed paths and checks to match the task:

```bash
packet_file="/tmp/hitl-review-packet.txt"

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

	printf '%s\n' 'Final operator-visible response'
	printf '%s\n' '-------------------------------'
	cat <<'FINAL_RESPONSE'
<paste the exact final operator-visible response text here>
FINAL_RESPONSE
	printf '\n'

	printf '%s\n' 'Commit status'
	printf '%s\n' '-------------'
	printf '%s\n' 'No commit was made.'
} > "$packet_file"

pbcopy < "$packet_file"
```

## Source-code project example

For source-code projects, include application source paths and project files as needed:

```bash
packet_file="/tmp/hitl-review-packet.txt"

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

	printf '%s\n' 'Final operator-visible response'
	printf '%s\n' '-------------------------------'
	cat <<'FINAL_RESPONSE'
<paste the exact final operator-visible response text here>
FINAL_RESPONSE
	printf '\n'

	printf '%s\n' 'Commit status'
	printf '%s\n' '-------------'
	printf '%s\n' 'No commit was made.'
} > "$packet_file"

pbcopy < "$packet_file"
```

## Final operator-visible response

At the end of the packet, include the final operator-visible assistant response
that the AI shows in chat.

This section is not an internal note. It is the exact final response the
operator sees.

A good workflow is:

1. Compose the final operator-visible response.
2. Include that exact response in the packet under `Final operator-visible response`.
3. Copy the packet to the clipboard.
4. Print the same final response in chat.

If a required session-preference reminder is part of what the operator sees at
the end of the final response, include that reminder in the packet exactly as it
will appear in chat.

The response MUST preserve the AI's concise judgment, findings,
recommendation, next-step guidance, bulleted lists, numbered lists, blank
lines, indentation, validation blocks, fenced or code-like blocks, footer
lines, and visible structure.

It should not duplicate the full diff or large logs already included elsewhere
in the packet unless the final operator-visible response itself includes them.

For example, the response may include:

- whether findings are blockers or non-blockers
- whether remaining issues are acceptable for the stated scope
- whether validation passed
- whether the review packet was copied
- whether a commit was intentionally not made
- the current session-preference reminder when applicable

The review packet should therefore contain both structured evidence and the
AI's final operator-visible interpretation of that evidence.

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
