# US-APDELTA-32 — CreateTable hydrates base_filter and has_create_action on the reduced state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a creation operation with base filter and create-action metadata.
When the reducer applies it.
Then both scalar values are visible in state.

Owned by the case `CreateTable hydrates base_filter and has_create_action on the reduced state` in `test/snapshot_delta_test.exs`.
