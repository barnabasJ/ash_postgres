# US-APDELTA-01 — initial operations retain explicit drop-table opt-out through the squash codec

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a reduced table with an explicit drop-table opt-out.
When initial operations pass through the squash codec.
Then the opt-out remains exactly as selected.

Owned by the case `initial operations retain explicit drop-table opt-out through the squash codec` in `test/snapshot_delta_test.exs`.
