# US-APDELTA-57 — reducing 100+ ops via direct apply_op yields the expected final state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given more than one hundred ordered native operations.
When the reducer applies the complete sequence.
Then the resulting state matches the expected collections.

Owned by the case `reducing 100+ ops via direct apply_op yields the expected final state` in `test/snapshot_delta_test.exs`.
