# US-APDELTA-49 — CreateTable → DropTable resets to empty state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a created table with attributes.
When DropTable is applied.
Then the reduced state resets to its empty table identity.

Owned by the case `CreateTable → DropTable resets to empty state` in `test/snapshot_delta_test.exs`.
