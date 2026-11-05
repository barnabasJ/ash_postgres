# US-APDELTA-23 — RenameAttribute: missing source is reported BEFORE existing destination

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a rename whose source is absent and destination already exists.
When the reducer validates it.
Then the missing-source conflict takes precedence.

Owned by the case `RenameAttribute: missing source is reported BEFORE existing destination` in `test/snapshot_delta_test.exs`.
