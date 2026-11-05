# US-APDELTA-09 — CreateTable + AddAttribute round-trip

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a CreateTable followed by AddAttribute.
When the list passes through the delta codec.
Then both native operations and column metadata survive.

Owned by the case `CreateTable + AddAttribute round-trip` in `test/snapshot_delta_test.exs`.
