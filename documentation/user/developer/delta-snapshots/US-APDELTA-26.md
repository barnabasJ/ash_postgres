# US-APDELTA-26 — state.empty? after add-then-remove-all reflects 'state was touched', not 'state is empty now'

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** an initially empty state.
- **When** an attribute is added and then removed.
- **Then** empty? records that state was touched.

Owned by the case `state.empty? after add-then-remove-all reflects 'state was touched', not 'state is empty now'` in `test/snapshot_delta_test.exs`.
