# US-APDELTA-55 — deltas without hash metadata still reduce — chain validation is opt-in

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a persisted chain without hash metadata.
- **When** the reader reduces it.
- **Then** hash validation remains optional and the operations apply.

Owned by the case `deltas without hash metadata still reduce — chain validation is opt-in` in `test/snapshot_delta_test.exs`.
