# US-APDELTA-40 — Add same identity twice raises conflict

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an existing identity.
- **When** another add uses the same identity key.
- **Then** the reducer rejects the duplicate.

Owned by the case `Add same identity twice raises conflict` in `test/snapshot_delta_test.exs`.
