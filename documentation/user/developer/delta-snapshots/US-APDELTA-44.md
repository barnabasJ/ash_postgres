# US-APDELTA-44 — Add → Remove leaves check_constraints empty

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an added check constraint.
- **When** it is removed in the same operation sequence.
- **Then** the final constraint collection is empty.

Owned by the case `Add → Remove leaves check_constraints empty` in `test/snapshot_delta_test.exs`.
