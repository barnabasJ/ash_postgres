# US-APDELTA-51 — RenameTable updates state.table and rejects mismatched old_table

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a table with a known name.
- **When** a rename is applied and an invalid old name is also attempted.
- **Then** the valid rename updates state and the invalid rename fails.

Owned by the case `RenameTable updates state.table and rejects mismatched old_table` in `test/snapshot_delta_test.exs`.
