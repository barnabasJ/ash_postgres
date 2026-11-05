# US-APDELTA-31 — Reducer preserves create_table_options on CreateTable — squash round-trip

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a table with create_table_options.
When its state is reduced and regenerated for squash.
Then the table options remain in reconstructed state.

Owned by the case `Reducer preserves create_table_options on CreateTable — squash round-trip` in `test/snapshot_delta_test.exs`.
