# US-APDELTA-06 — schema moves survive the codec and update the reduced schema

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a schema-move operation from the default schema to archive.
When its persisted form is decoded and reduced.
Then the reduced schema becomes archive.

Owned by the case `schema moves survive the codec and update the reduced schema` in `test/snapshot_delta_test.exs`.
