# US-APDELTA-16 — CreateTable carries base_filter and has_create_action through round-trip

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a table with base filter and create-action metadata.
When its creation operation is encoded and decoded.
Then both scalar values survive.

Owned by the case `CreateTable carries base_filter and has_create_action through round-trip` in `test/snapshot_delta_test.exs`.
