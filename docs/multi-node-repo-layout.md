# Multi-Node Repo Layout

This document defines repository layout standards for secure systems that span multiple deployment targets and trust boundaries.

It applies to infrastructure repositories where one repository describes several nodes, relays, clients, and trusted internal resources.

This is not a toy smart-home layout.

It is an operational structure for threat-aware systems where public exposure, private network access, deployment ownership, and publication risk must stay visible.

## Core pattern

A multi-node repository should make the system boundary visible immediately:

```text
external client
    ->
public relay
    ->
private tunnel
    ->
internal relay
    ->
trusted LAN resource
```

The exact nodes vary by project.

The standard does not require one transport, one device class, or one deployment tool.

It requires the repository to show:

- what runs where
- which node owns each file
- which boundary each node crosses
- what is shared across nodes
- what is private runtime state
- what is safe to publish

## Canonical layout

```text
project-name/
├── README.md
├── nodes/
├── shared/
├── tools/
├── docs/
├── assets/
└── directory_structures/
```

`nodes/` contains deployment targets or trust-boundary roles.

`shared/` contains reusable code, schemas, protocols, message formats, or documentation fragments used by more than one node.

`tools/` contains operator tooling, audit tooling, import helpers, release checks, and maintenance scripts.

`docs/` contains architecture, threat model, deployment notes, sanitization notes, runbooks, and repository-specific decisions.

`assets/` contains sanitized diagrams, reference screenshots, static media, or publication-safe supporting material.

`directory_structures/` contains reusable example files, config templates, service templates, and scaffolding that can be copied into node-local deployment paths.

Use only what the project needs.

Do not add empty ceremony.

## Node-scoped deployment structure

Use `nodes/` when one repository describes multiple deployment targets.

Examples:

```text
nodes/
├── iphone/
├── wg-server/
└── pi/
```

Each directory represents a node, deployment target, or trust-boundary role.

Good node names are short, lowercase, and operational:

```text
nodes/iphone/
nodes/wg-server/
nodes/pi/
nodes/home-relay/
nodes/public-relay/
```

Avoid names that hide the boundary:

```text
nodes/misc/
nodes/stuff/
nodes/server2/
nodes/new/
```

A single repository may describe several deployment targets when those targets are part of one coherent system.

The repository should not pretend those targets have the same trust level.

For example:

```text
nodes/wg-server/    public-facing relay and tunnel endpoint
nodes/pi/           internal relay with no inbound public exposure
nodes/iphone/       client automation or shortcut export notes
```

Each node should own its local deployment files.

If a systemd unit runs on the Raspberry Pi, it belongs under `nodes/pi/`.

If a reverse proxy config runs on the public relay, it belongs under `nodes/wg-server/`.

If a Shortcut invokes the public relay, its documentation or sanitized export notes belong under `nodes/iphone/`.

## Trust boundaries

The layout should reinforce the security model.

For a secure relay architecture, the repository should make these boundaries explicit:

- no inbound exposure to the internal relay
- no direct public access to trusted LAN resources
- no port-forwarded internal services
- public relay separated from trusted LAN resources
- tunnel-based access between public relay and internal relay
- clear distinction between public endpoint behavior and private LAN behavior

The repository structure should help an operator answer:

```text
What can the internet reach?
What can only the tunnel reach?
What can only the trusted LAN reach?
What must never be committed?
What can be safely published after review?
```

## `nodes/` is not `_`

`nodes/` and a possible future `_` support namespace solve different problems.

`nodes/` represents deployment targets or trust-boundary roles.

The `_` directory abstraction is shelved for now and is not a default
project-structure convention.

Do not use `_` as a substitute for `nodes/`.

Good:

```text
nodes/wg-server/webhookd/
├── webhook.sh
└── web/
    ├── index.php
    ├── assets/
    ├── css/
    └── js/
```

Bad:

```text
_/
├── iphone/
├── wg-server/
└── pi/
```

The first structure says which deployment target owns the files.

The second hides the trust boundary inside a vague support directory.

## Outside working directory config tracking

Infrastructure systems often depend on files that live outside the repository working directory at runtime.

Track those files safely as templates or sanitized snapshots.

Suggested node-local structure:

```text
nodes/<node>/
├── systemd/
├── proxy/
├── wireguard/
├── firewall/
└── cron/
```

Use these directories for:

- `systemd/` service and timer templates
- `proxy/` reverse proxy templates or sanitized active-site snapshots
- `wireguard/` interface and peer templates with no live keys
- `firewall/` sanitized firewall rule snapshots
- `cron/` cron templates or sanitized crontab snapshots

Templates should use placeholders:

```text
<public-hostname>
<wireguard-interface>
<internal-relay-host>
<service-user>
<path-to-working-copy>
```

Sanitized snapshots may show structure and intent, but must not expose live secrets, live private keys, public keys that should remain unlinked, internal hostnames, account names, home network details, private IP assignments, tokens, or operational identifiers that are not needed for publication.

Never commit live secrets.

Never commit live private keys.

Never commit production certificates.

Never commit unreviewed active configs from sensitive infrastructure.

## Runtime-state separation

Runtime state should not be mixed with source, documentation, templates, or deployment descriptors.

Common runtime-state paths:

```text
db/
logs/
env/
keys/
certs/
tokens/
captures/
```

These paths should usually be ignored.

If a project needs examples, commit synthetic or sanitized material under an explicit training or examples path.

Prefer:

```text
training/
├── events.sample.json
└── webhook-request.sample.json
```

Avoid:

```text
db/live.sqlite
logs/access.log
env/.env
keys/wg-private.key
certs/fullchain.pem
tokens/api-token.txt
captures/real-request.json
```

Use a quarantine model for raw imports and local-only review material:

```text
private/
├── raw-import/
├── captures/
└── review/
```

`private/` is for material that may be operationally useful but is not publication-safe by default.

It should be ignored unless there is a specific private-repository reason to track it.

`training/` is for sanitized examples that intentionally teach the system shape without exposing the real environment.

## OPSEC-conscious publication workflow

Publication is an operational event.

Before public release, the repository should distinguish:

```text
private/      local quarantine and raw review material
training/     sanitized or synthetic samples
tools/audit/  repeatable audit and release checks
```

Recommended audit tooling:

```text
tools/audit/
├── sanitize_scan.sh
└── public_release_check.sh
```

`sanitize_scan.sh` should search for obvious exposure risks such as private keys, tokens, local absolute paths, `.env` files, certificate material, internal hostnames, and unreviewed captures.

`public_release_check.sh` should compose the release checks that matter for the repository before export, publication, tagging, or portfolio use.

These tools do not replace judgment.

They make judgment repeatable.

A controlled public export should verify:

- ignored private material is absent
- templates do not contain live secrets
- docs do not expose unnecessary operational identifiers
- screenshots and assets have been reviewed
- training data is synthetic or sanitized
- git history risk has been considered
- README explains what is intentionally excluded

If sensitive material has entered history, removing it from the current tree may not be enough.

The correct response may include credential rotation, history rewriting, repository recreation, or deciding not to publish the repository.

## Shelved `_` support directory usage

Do not require or introduce `_` directories inside node-local applications by
default.

Keep `_` only as a possible future support namespace for operator, process,
generated, or local-support artifacts if repeated real repository structures
show that clear ordinary directories are not enough.

If this pattern is revived, directory names beneath it should describe what the
files are and should support a clear local entrypoint or application surface.

Shared cross-node code belongs in `shared/`.

Operator scripts belong in `tools/`.

Node deployment files belong in `nodes/<node>/`.

## Audit mode

Use audit mode when a repository already has `nodes/`.

Audit mode asks whether the existing layout follows the standard without changing repository state.

Review:

- whether each node represents a real deployment target or trust-boundary role
- whether node-local configs live under the owning node
- whether shared material is actually shared
- whether runtime state is ignored
- whether private quarantine and sanitized training data are separated
- whether any `_` usage is intentional, documented, and not acting as a default
  or vague substitute for meaningful directories
- whether publication tooling exists for OPSEC review
- whether docs explain the trust boundaries

Audit mode is report-only.

It should identify findings and recommended remediation, but should not move, rename, redact, delete, normalize, publish, or commit files without explicit approval.

## Migration and scaffolding mode

Use migration or scaffolding mode when a repository does not yet have `nodes/` but clearly represents a multi-node system.

Introduce `nodes/` from real deployment and trust boundaries.

Do not reorganize aggressively just because the standard exists.

Migration should preserve operational continuity.

A safe migration path:

1. Map the current deployment targets.
2. Identify which files run on which node.
3. Identify shared files used by more than one node.
4. Create `nodes/<node>/` directories for real boundaries.
5. Move or copy only low-risk documentation and templates first.
6. Update references and deployment notes.
7. Leave runtime state ignored.
8. Add audit tooling before public release.

The repository should become clearer after each step.

If a move would break deployment, defer it and document the transition.

The goal is not to satisfy a tree diagram.

The goal is to make the system easier to understand, operate, audit, and publish safely.

## Rule of thumb

A multi-node infrastructure repository should answer the first security question quickly:

```text
Where does this run, and what boundary does it cross?
```

If the layout cannot answer that, the structure is hiding operational risk.
