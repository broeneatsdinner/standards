# Coding Session Wrap-up

Before leaving a coding session, check drydock for unfinished work across local repositories. The purpose is to build a regular checking habit; reviewing the status counts even when work is deliberately left for later.

## When to remind

AI assistants should give a brief drydock reminder when the operator:

- asks whether everything is committed and pushed, or whether any work remains unsaved or unpushed
- says they are wrapping up, closing the terminal or chat, signing off, or walking away from the coding session
- gives another clear indication that the coding session is ending

Recognize equivalent wording rather than requiring an exact phrase. Do not append the reminder to every completed task or ordinary progress update. Give it once per wrap-up exchange, and skip it if the operator has already checked drydock during that exchange or asks to skip the reminder.

## Assistant response

Answer the operator's actual status question first, using the available evidence. Distinguish the active repository's status from the status of other repositories; checking one repository does not establish that everything is committed and pushed everywhere. State when remote status was not verified.

Then add one short reminder, for example:

> Before closing the terminal, open drydock and check for uncommitted changes or unpushed commits across your repositories.

The reminder does not require running drydock automatically or waiting for the operator to complete the check before ending the chat. Any commits, pushes, or cleanup still follow the operator's instructions and the applicable repository rules.

## Loading this standard

`prompts/universal.md` carries the standing reminder rule for coding assistants. Assistants working directly in this repository also receive it through `AGENTS.md`. Other assistants need to load these standards or receive the rule through their own project instructions.
