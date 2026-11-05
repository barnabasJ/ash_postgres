# US-APDELTA-07 — serial sequence rendering preserves the paired attribute state

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a serial-sequence renderer operation.
- **When** its persisted form is decoded and applied.
- **Then** the operation survives without changing logical attributes.

Owned by the case `serial sequence rendering preserves the paired attribute state` in `test/snapshot_delta_test.exs`.
