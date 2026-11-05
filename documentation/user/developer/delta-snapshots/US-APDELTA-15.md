# US-APDELTA-15 — OptOutDropTable round-trips

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a drop-table opt-out operation.
- **When** its delta JSON is decoded.
- **Then** the explicit opt-out operation survives.

Owned by the case `OptOutDropTable round-trips` in `test/snapshot_delta_test.exs`.
