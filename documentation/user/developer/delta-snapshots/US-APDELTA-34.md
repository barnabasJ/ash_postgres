# US-APDELTA-34 — Add → Rename → Remove (by new name) succeeds

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an added attribute.
- **When** it is renamed and then removed by its new source.
- **Then** the final attribute collection is empty.

Owned by the case `Add → Rename → Remove (by new name) succeeds` in `test/snapshot_delta_test.exs`.
