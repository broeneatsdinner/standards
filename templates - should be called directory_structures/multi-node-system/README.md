# multi-node-system

Template scaffold for a threat-aware multi-node infrastructure repository.

Use this when one repository describes several deployment targets or trust-boundary roles.

## Structure

```text
multi-node-system/
├── README.md
├── .gitignore
├── docs/
├── nodes/
├── shared/
├── tools/
├── training/
└── assets/
```

## Directory meanings

```text
nodes/     deployment targets and trust-boundary roles
shared/    cross-node code, schemas, protocols, and reusable definitions
tools/     operator tooling, audit checks, and maintenance scripts
docs/      architecture, threat model, deployment notes, and sanitization notes
assets/    sanitized diagrams, screenshots, and publication-safe references
training/  synthetic or sanitized sample data
private/   ignored quarantine area for raw local material
```

## Publication boundary

Do not commit live secrets, private keys, certificates, tokens, local captures, real `.env` files, or unreviewed active infrastructure configs.

Use `private/` for quarantine and `training/` for sanitized examples.

Before public release, run:

```bash
bash tools/audit/sanitize_scan.sh
bash tools/audit/public_release_check.sh
```

The audit scripts expect `rg` from ripgrep to be available.
