# US-APDI-037 — context multitenancy in delta mode produces a tenant migration that runs via migrate_tenant

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through generated migrations are runnable.

## Scenario

Given a static context-multitenant resource has native tenant migration files.
When the public migrate_tenant function applies them to a case-owned schema inside SQL Sandbox.
Then the tenant table and label column exist in that schema.

Coverage: `US-APDI-037` in `test/delta_mode_runnable_sql_test.exs`.
