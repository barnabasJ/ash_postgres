# US-APMG-041 — Codegen checks reject pending changes without writing files

As a developer, I need codegen checks to report actionable pending work without changing migration files.

Given a real resource whose initial migration and snapshot are absent,

When native generation runs with check true,

Then it raises PendingCodegen and the case-owned resource migration and snapshot wildcards remain empty.

Owning case: `test/migration_generator_check_test.exs`, story tag `US-APMG-041`.

Status: source migrated; executable verification pending.
