# Architecture

Document the deployment targets, trust boundaries, and information flow.

Example boundary shape:

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

Explain what each node can reach and what it must not expose.
