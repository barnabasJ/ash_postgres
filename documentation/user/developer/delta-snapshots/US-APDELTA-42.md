# US-APDELTA-42 — Add → Rename to a different name succeeds and updates state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an existing identity.
When a rename changes its name.
Then the reduced identity uses the new name.

Owned by the case `Add → Rename to a different name succeeds and updates state` in `test/snapshot_delta_test.exs`.
