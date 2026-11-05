# US-APDELTA-04 — temporal foreign-key operations retain their actual SQL period fields

As a developer, I need persisted delta snapshots to preserve migration semantics and reject inconsistent changes.

Given a temporal foreign-key operation with distinct source and destination periods.
When its persisted form is decoded and rendered.
Then both SQL periods and all native operation fields survive.

Owned by the case `temporal foreign-key operations retain their actual SQL period fields` in `test/snapshot_delta_test.exs`.
