# US-APDELTA-48 — Add same custom index twice raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an existing custom index.
- **When** a second add targets it.
- **Then** the reducer rejects the duplicate.

Owned by the case `Add same custom index twice raises conflict` in `test/snapshot_delta_test.exs`.
