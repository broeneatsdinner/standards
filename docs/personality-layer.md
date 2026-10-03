# Personality Layer

This document defines the `personality/` directory: a written design layer, kept in the repository next to the code, that describes how an application treats the people using it.

Every user-facing application I build should have one.

## Why this exists

Code defines what an application does. It rarely defines, on purpose, how the application talks to people: what an error says, how a guess is offered, what a waiting state looks like, whether a mistake feels like a shared gap or a verdict.

When nobody decides that deliberately, it gets decided message by message, by whoever happens to write each string. The result is not neutral. Software with no deliberate voice defaults to a cold one.

The `personality/` directory makes the voice a design decision instead of a byproduct. Because it lives in the repository, it is versioned, reviewed, and read by the same people and AI agents who write the user-facing text.

## What it is not

- It is not a brand guide for marketing.
- It is not a collection of jokes.
- It does not change runtime behavior on its own. It is a design reference that code is held to.

## Shared principles

These principles apply to every application. Each application's `personality/` inherits them and adds its own character on top.

### Assume the system misunderstood before assuming the user is wrong

When input and expectation don't match, the default assumption is that the system failed to understand, not that the person failed to comply. Prefer "I don't understand this yet. Let's try again." over "Invalid input." The first locates the gap in the system, signals that it is temporary, and invites another attempt.

### Distinguish failure categories

Before writing an error, know which kind of failure it is, and talk about each differently:

- **User mistake**: the request, understood correctly, doesn't make sense or doesn't exist. Stay informative, not corrective, and offer what does exist nearby.
- **Misunderstood intent**: the meaning was clear or nearly clear, but didn't match the expected shape. Try to resolve it before ever surfacing an error.
- **Unsupported capability**: the request was understood precisely; the application doesn't do that (yet). Name the missing capability. Don't imply the person asked wrong.
- **Environment failure**: something outside the person's input broke (network, file, permissions, a remote service). They did nothing wrong. Say what broke in actionable terms, and say what was preserved.

A technically correct error can still fail its real job. The measure of a good error is whether the person's next action gets easier because they read it.

### Disclose inferences; ask instead of assume

When the system infers something on the person's behalf, it says so. When an inference is plausible but not certain, it is offered as a question rather than asserted as a fact. Silent guessing teaches nothing and erodes trust the first time the guess is wrong.

The same rule applies to data: what a person states is recorded as stated, and what the system infers stays labeled as inference.

### Suggest, don't command

The application informs decisions the person still makes. Prefer conditional, suggestive phrasing ("if you're heading out, you might want to…") over imperative phrasing ("you need to…"), especially when the application is predicting rather than knowing.

### Show only what the system actually knows

Don't present precision the system doesn't have. No progress bar without a known target, no confident wording for a guess, no ETA without a destination.

### Presence over silence

Personality is not only in final responses. It is also in progress indicators, status messages, waiting states, confirmations, and transitions. "I am still working" is a different message than silence.

### Humor is rare, contextual, and rewarding

Humor is never the default register. When it appears, it must arise from the specific situation, be impossible to trigger on demand, and make the person feel delighted, never like the punchline. Sarcasm is out of scope: it requires judging the listener.

### Keep it short

Brevity is part of the respect being shown. Say what happened, then what to do about it, and stop.

## Required structure

```text
personality/
├── README.md               what this directory is and how to use it
├── DESIGN.md               goals, inspirations, what the app should and should not feel like
├── voice.md                who is speaking, who is not, working rules
├── error-philosophy.md     the failure categories applied to this app, with real examples
├── intent.md               how the app resolves what the person probably meant, and how it discloses that
├── easter-eggs.md          this app's bar for humor (philosophy, not the jokes themselves)
└── conversations/          design history: why decisions in this layer were made
```

`intent.md` may take an app-appropriate name. A command-line tool may call it `command-intent.md`; an app that predicts behavior might call it `inference.md`. Its job is the same: how the app turns a near-miss or a likely guess into help, and how it tells the person what it inferred.

A starter template lives in [`directory_structures/personality-layer/`](../directory_structures/personality-layer/).

## Per-application character

The structure is shared. The character is not. Each application chooses who is speaking, based on the world it lives in. For example:

- a terminal tool steeped in BBS and ANSI culture might speak as a friendly sysop, a patient terminal companion, and a knowledgeable archivist
- a commute or daily-routine app might speak as a thoughtful neighbor who knows the roads: notices things, mentions them conditionally, never bosses anyone around

Write the character down in `voice.md`, including who is explicitly not speaking (a chatbot, a joke generator, a sarcastic assistant, a dispatcher).

## When to consult it

Read the relevant `personality/` files before writing or changing:

- error messages and hints
- responses to unrecognized or ambiguous input
- prompts, questions, and confirmations
- notifications, alerts, and scheduled messages
- progress, status, and waiting states
- onboarding and empty states

AI coding agents working in a repository with a `personality/` directory should read `voice.md` and `error-philosophy.md` before writing user-facing text, and `intent.md` before changing input handling or prediction behavior.

## Conversations as design history

`conversations/` preserves the reasoning behind decisions in this layer: dated records of the discussion that produced a rule, so the "why" survives after context is lost. When an operator's own words shaped a decision, record them verbatim, with any interpretation clearly marked as interpretation.

## Reference implementation

The CP437 project's `personality/` directory is the reference implementation of this standard (a private repository). Its structure and principles are reflected in the template.
