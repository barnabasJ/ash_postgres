# US-APDELTA-05 — initial temporal state survives codegen, the delta codec and reduction

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a desired initial temporal table.
When native initial operations are encoded and reduced.
Then the primary key flags and temporal state match the desired snapshot.

Owned by the case `initial temporal state survives codegen, the delta codec and reduction` in `test/snapshot_delta_test.exs`.
