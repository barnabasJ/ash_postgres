# US-APDELTA-27 — returns nil for an empty directory

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a snapshot directory with no deltas.
- **When** the persisted-state reader loads it.
- **Then** it returns nil.

Owned by the case `returns nil for an empty directory` in `test/snapshot_delta_test.exs`.
