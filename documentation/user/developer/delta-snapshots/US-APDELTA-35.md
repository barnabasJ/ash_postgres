# US-APDELTA-35 — Add → Rename → Rename again (chained renames) follows the new identity

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an attribute with successive source names.
- **When** two renames execute in sequence.
- **Then** the final state follows the last source name.

Owned by the case `Add → Rename → Rename again (chained renames) follows the new identity` in `test/snapshot_delta_test.exs`.
