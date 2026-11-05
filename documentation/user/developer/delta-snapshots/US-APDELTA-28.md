# US-APDELTA-28 — rejects legacy full-state files with a clear error

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a legacy full-state file in a delta directory.
- **When** the persisted-state reader loads it.
- **Then** it requests the native migrate_snapshots conversion.

Owned by the case `rejects legacy full-state files with a clear error` in `test/snapshot_delta_test.exs`.
