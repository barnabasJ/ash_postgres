# US-APMG-086 — Check mode reports pending codegen without warning output or files

As a developer, I need migration review messages to match the actual safety mode and generated operations.

Given a real additive resource whose generation is pending,

When native generation runs with check true inside native process-local capture,

Then it raises PendingCodegen, resource migration and snapshot wildcards stay empty and captured output is empty.

Owning case: `test/migration_generator_review_warnings_test.exs`, story tag `US-APMG-086`.

Status: source migrated; executable verification pending.
