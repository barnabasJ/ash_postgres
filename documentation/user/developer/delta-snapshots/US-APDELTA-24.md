# US-APDELTA-24 — RenameAttribute: existing destination throws after source-found check

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a rename with an existing source and occupied destination.
When the reducer validates it.
Then it rejects the occupied destination.

Owned by the case `RenameAttribute: existing destination throws after source-found check` in `test/snapshot_delta_test.exs`.
