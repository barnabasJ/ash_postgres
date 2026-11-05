# US-APDELTA-11 — AddAttribute with references + nilify on_delete round-trips

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** a foreign-key attribute with nilify columns.
- **When** its delta JSON is decoded.
- **Then** the reference and nilify column semantics survive.

Owned by the case `AddAttribute with references + nilify on_delete round-trips` in `test/snapshot_delta_test.exs`.
