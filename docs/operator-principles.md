# Operator Principles

This document defines the operating principles behind my tools, scripts, project structures, and standards.

## Core identity

I enter unfamiliar systems, map how they work, identify what matters, and organize them so teams do not get lost.

This applies to:

- shell environments
- local machines
- servers
- repositories
- websites
- automation workflows
- security tooling
- project documentation
- AI-assisted development

## Structure is operational

Structure is not decoration.

Structure determines how quickly a person can understand a system, how safely a tool can operate, and how easily work can continue after context is lost.

A good structure reduces cognitive load.

A bad structure creates hidden risk.

## Make intent visible

A system should reveal:

- what it is
- where things live
- what is safe to touch
- what is generated
- what is public
- what is private
- what is reusable
- what is an entrypoint
- what is internal support code

## Reduce ambiguity

Ambiguity causes wasted time, unsafe assumptions, and duplicated work.

Standards exist to reduce ambiguity.

The goal is not rigid control.

The goal is making systems easier to operate.

## Prefer calm tools

Good tools should feel calm.

They should be clear, predictable, recoverable, and direct.

They should not surprise the operator.

They should not hide important behavior behind cleverness.

## Safety is design

A good operator tool should make dangerous actions obvious.

For modifying workflows:

- preview first when practical
- dry-run by default when appropriate
- require explicit confirmation for destructive actions
- print what changed
- fail clearly
- leave recoverable state when possible

## Humans and machines

These standards are for both humans and machines.

Humans should be able to understand the work quickly.

AI coding tools should be able to apply the style consistently.

Scripts should be able to rely on predictable locations and naming.

## Public work

Public repositories should show how I think.

They should demonstrate:

- clarity
- taste
- structure
- operational discipline
- practical automation
- maintainability
- security-minded habits

## Rule of thumb

Do not merely make things work.

Make them understandable, repeatable, and operable.
