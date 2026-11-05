# US-APDELTA-17 — CreateTable.has_create_action defaults to true when absent from a decoded op

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a historical CreateTable delta without has_create_action.
- **When** the reader decodes it.
- **Then** the historical true default applies.

Owned by the case `CreateTable.has_create_action defaults to true when absent from a decoded op` in `test/snapshot_delta_test.exs`.
