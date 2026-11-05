# US-APDELTA-61 — reducer ignores non-delta files in the snapshot directory

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a delta directory containing ordinary files and malformed backup filenames.
When the reader loads persisted deltas.
Then it ignores those files and reduces only valid timestamped JSON.

Owned by the case `reducer ignores non-delta files in the snapshot directory` in `test/snapshot_delta_test.exs`.
