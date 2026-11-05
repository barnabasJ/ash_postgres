# US-APDELTA-52 — OptOutDropTable sets the flag without otherwise mutating state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a populated reduced state.
- **When** OptOutDropTable is applied.
- **Then** only the explicit opt-out flag changes.

Owned by the case `OptOutDropTable sets the flag without otherwise mutating state` in `test/snapshot_delta_test.exs`.
