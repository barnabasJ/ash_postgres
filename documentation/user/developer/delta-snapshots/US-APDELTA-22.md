# US-APDELTA-22 — AlterAttribute that changes references honors the new reference

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an attribute whose reference changes.
- **When** the new reference is applied.
- **Then** the new reference replaces the old one.

Owned by the case `AlterAttribute that changes references honors the new reference` in `test/snapshot_delta_test.exs`.
