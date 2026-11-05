# US-APDELTA-43 — Rename non-existent identity raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an absent identity.
- **When** a rename targets it.
- **Then** the reducer reports the missing identity.

Owned by the case `Rename non-existent identity raises conflict` in `test/snapshot_delta_test.exs`.
