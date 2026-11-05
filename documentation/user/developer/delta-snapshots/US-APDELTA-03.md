# US-APDELTA-03 — legacy unique-index deltas do not require the new renderer fields

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a historical unique-index delta without temporal fields.
When the current codec decodes it.
Then native defaults apply and the removed placement field is ignored.

Owned by the case `legacy unique-index deltas do not require the new renderer fields` in `test/snapshot_delta_test.exs`.
