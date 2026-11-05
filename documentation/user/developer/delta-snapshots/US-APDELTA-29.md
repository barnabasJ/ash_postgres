# US-APDELTA-29 — reduces a single delta to state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a persisted initial delta.
- **When** the state reader loads its directory.
- **Then** the resulting state contains its table and attributes.

Owned by the case `reduces a single delta to state` in `test/snapshot_delta_test.exs`.
