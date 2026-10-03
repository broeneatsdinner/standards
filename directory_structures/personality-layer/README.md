# personality-layer

Starter template for an application's `personality/` directory: the written design layer that describes how the application treats the people using it.

See [`docs/personality-layer.md`](../../docs/personality-layer.md) for the standard, the shared principles every application inherits, and when to consult the layer.

## Structure

```text
personality/
├── README.md
├── DESIGN.md
├── voice.md
├── error-philosophy.md
├── intent.md
├── easter-eggs.md
└── conversations/
    └── README.md
```

## Using the template

1. Copy `personality/` into the root of the application repository.
2. Rename `intent.md` if a more specific name fits (`command-intent.md` for a command-line tool, `inference.md` for an app that predicts behavior), and update links.
3. Replace every `TODO` with this application's actual answers. Delete guidance text once it has been answered.
4. Record the conversation that produced the character as the first entry in `conversations/`.
5. Point the repository's agent instructions (`AGENTS.md` or equivalent) at `personality/README.md`.
