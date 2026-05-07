Most candidates show projects.

I am showing the operating system behind the projects:

```text
how I think
how I standardize
how I reduce ambiguity
how I scale my own work
how I make AI-assisted work repeatable
how I turn taste into infrastructure
```

This repository is easy to misread as shell polish or repo hygiene.

The deeper value is that it codifies operational systems thinking:

```text
taxonomy
workflow standards
naming conventions
publication pipelines
OPSEC methodology
audit prompts
AI-operational prompts
exemplar repository patterns
```

The standards are written so humans can follow them and AI systems can operationalize them.

Most public repositories stop at one layer: style guidance, naming rules, prompt snippets, OPSEC checklists, or documentation advice.

This one connects those layers into a repeatable operating system.

The repository demonstrates how technical systems should be documented, reviewed, made repeatable, and prepared for public release.

The credibility is in the structure itself: the taxonomy, workflows, prompts, OPSEC methodology, and exemplar repository patterns are all present as working standards, not described as aspirations.

The publication OPSEC prompt architecture is a concrete example.

It is not a single magic prompt that both audits and changes a repository.

It is an ordered workflow whose filenames make the sequence visible in terminal and GitHub file listings:

```text
publication-opsec-01-initiate.md
publication-opsec-02-audit.md
publication-opsec-03-text-remediation.md
publication-opsec-04-media-remediation.md
```

That structure is legible to humans and machines at the same time.

Initiation, audit, and remediation are separated.

Audit remains report-only.

Remediation requires approved, scoped follow-up prompts.

That boundary prevents silent mutation, review bypass, one giant magic prompt behavior, and ambiguity about whether the AI has authority to change the repository.

The workflow demonstrates operational and security maturity by encoding control points directly into the repository structure.

This approach is especially relevant for security, AI security, platform, tooling, and operator roles.

I do not just build scripts.

I build systems that keep work coherent.
