# US-APDELTA-58 — reducing 60 delta files from disk in timestamp order yields the same state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** sixty delta files stored on disk.
- **When** the directory reader reduces them.
- **Then** the result matches the equivalent ordered in-memory reduction.

Owned by the case `reducing 60 delta files from disk in timestamp order yields the same state` in `test/snapshot_delta_test.exs`.
