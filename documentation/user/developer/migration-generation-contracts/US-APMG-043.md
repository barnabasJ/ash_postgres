# US-APMG-043 — Codegen checks do not infer ambiguous renames

As a developer, I need codegen checks to report actionable pending work without changing migration files.

Given persisted old_a/old_b columns and an immutable next resource containing new_a/new_b,

When native generation runs with check true,

Then it raises PendingCodegen whose proposed file diff does not contain a rename operation.

Owning case: `test/migration_generator_check_test.exs`, story tag `US-APMG-043`.

Status: source migrated; executable verification pending.
