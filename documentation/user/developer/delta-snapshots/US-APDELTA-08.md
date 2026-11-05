# US-APDELTA-08 — simple AddAttribute round-trips

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a text AddAttribute operation.
When its delta JSON is decoded.
Then its operation type, source and database type survive.

Owned by the case `simple AddAttribute round-trips` in `test/snapshot_delta_test.exs`.
