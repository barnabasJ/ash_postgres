# US-APDELTA-13 — rejects malformed JSON with a parseable error message

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

- **Given** malformed JSON.
- **When** the delta reader parses it.
- **Then** it reports an informative parse error.

Owned by the case `rejects malformed JSON with a parseable error message` in `test/snapshot_delta_test.exs`.
