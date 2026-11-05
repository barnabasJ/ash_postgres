# US-APDI-016 — attribute multitenancy persists the tenancy attribute in ops

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through multitenancy.

## Scenario

Given a resource uses attribute multitenancy.
When native delta generation serializes its operations.
Then the tenancy attribute remains in the encoded state.

Coverage: `US-APDI-016` in `test/delta_mode_multitenancy_test.exs`.
