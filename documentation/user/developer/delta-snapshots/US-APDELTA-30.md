# US-APDELTA-30 — CreateTable#create_table_options encode + decode preserves value

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an explicit create_table_options value.
When the creation operation is encoded and decoded.
Then the table options retain their value.

Owned by the case `CreateTable#create_table_options encode + decode preserves value` in `test/snapshot_delta_test.exs`.
