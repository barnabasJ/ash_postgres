# US-APDELTA-39 — Add → Remove leaves identities empty

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given an identity.
When it is added and then removed.
Then the final identity collection is empty.

Owned by the case `Add → Remove leaves identities empty` in `test/snapshot_delta_test.exs`.
