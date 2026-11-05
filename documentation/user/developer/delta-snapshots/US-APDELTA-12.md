# US-APDELTA-12 — rejects non-v2 JSON with an informative error

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a non-v2 JSON object.
When the delta reader receives it.
Then it rejects the format and identifies the expected version.

Owned by the case `rejects non-v2 JSON with an informative error` in `test/snapshot_delta_test.exs`.
