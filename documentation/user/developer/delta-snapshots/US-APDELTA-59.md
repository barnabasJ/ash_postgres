# US-APDELTA-59 — encoding the same op list with different map key orders produces the same JSON

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given equivalent operation maps with different key insertion orders.
When the codec encodes both lists.
Then the JSON output is identical.

Owned by the case `encoding the same op list with different map key orders produces the same JSON` in `test/snapshot_delta_test.exs`.
