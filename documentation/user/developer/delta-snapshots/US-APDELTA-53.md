# US-APDELTA-53 — two deltas with matching previous→resulting hashes reduce cleanly

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** two persisted deltas with matching hash linkage.
- **When** the reader reduces them in sequence.
- **Then** the chain is accepted and both operations apply.

Owned by the case `two deltas with matching previous→resulting hashes reduce cleanly` in `test/snapshot_delta_test.exs`.
