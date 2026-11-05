# US-APDI-015 — resources with context multitenancy store deltas under tenants/

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through multitenancy.

## Scenario

Given a resource uses context multitenancy.
When native delta generation writes the resource snapshots.
Then the delta is stored under the tenant snapshot directory.

Coverage: `US-APDI-015` in `test/delta_mode_multitenancy_test.exs`.
