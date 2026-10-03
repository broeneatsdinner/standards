# personality/

This directory defines how this application interacts with humans.

It is not a collection of jokes. It is a design layer describing the relationship between the person and the software: what tone the software takes, how it responds when it doesn't understand, how it offers guesses, and why.

Application code defines *what the application does*. This directory describes *how it treats the people using it*. It does not change runtime behavior on its own; it is the reference that user-facing text and input handling are held to.

This layer follows the shared standard in the standards repository (`docs/personality-layer.md`) and adds this application's own character.

## Contents

- [`DESIGN.md`](DESIGN.md): goals, inspirations, and what this application should and should not feel like.
- [`voice.md`](voice.md): who is speaking, who is not, and the working rules for writing messages.
- [`error-philosophy.md`](error-philosophy.md): how this application distinguishes and talks about each kind of failure.
- [`intent.md`](intent.md): how this application resolves what the person probably meant, and how it discloses inferences.
- [`easter-eggs.md`](easter-eggs.md): the bar humor has to clear in this application.
- [`conversations/`](conversations/): design history, so the reasoning behind this layer isn't lost.

## How to use this directory

Before writing or editing an error, hint, prompt, confirmation, notification, or status message, read `voice.md` and `error-philosophy.md`. Before changing input handling or anything that guesses on the person's behalf, read `intent.md`. Before adding humor, read `easter-eggs.md`.
