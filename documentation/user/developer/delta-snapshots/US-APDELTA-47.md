# US-APDELTA-47 — Add → Remove cycles cleanly

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an explicit custom index.
When it is added and then removed.
Then the final custom-index collection is empty.

Owned by the case `Add → Remove cycles cleanly` in `test/snapshot_delta_test.exs`.
