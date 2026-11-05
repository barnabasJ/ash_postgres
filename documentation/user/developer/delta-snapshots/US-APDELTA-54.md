# US-APDELTA-54 — previous_hash that doesn't match prior resulting_hash raises ConflictError

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** two persisted deltas with inconsistent hash linkage.
- **When** the reader reduces them.
- **Then** it rejects the broken hash chain.

Owned by the case `previous_hash that doesn't match prior resulting_hash raises ConflictError` in `test/snapshot_delta_test.exs`.
