# US-APDELTA-25 — AddCustomStatement / RemoveCustomStatement round-trip through apply_op

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a custom statement.
- **When** add and remove operations pass through the codec and reducer.
- **Then** the statement can be added and removed with its semantics intact.

Owned by the case `AddCustomStatement / RemoveCustomStatement round-trip through apply_op` in `test/snapshot_delta_test.exs`.
