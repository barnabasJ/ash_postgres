# US-APDELTA-14 — rejects JSON that isn't a top-level object

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a valid JSON value that is not an object.
When the delta reader receives it.
Then it rejects the top-level shape.

Owned by the case `rejects JSON that isn't a top-level object` in `test/snapshot_delta_test.exs`.
