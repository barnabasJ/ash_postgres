# US-APDELTA-38 — Remove → Add at the same source is allowed (re-add cycle)

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an attribute removed from state.
- **When** a later AddAttribute reuses that source.
- **Then** the new attribute is accepted.

Owned by the case `Remove → Add at the same source is allowed (re-add cycle)` in `test/snapshot_delta_test.exs`.
