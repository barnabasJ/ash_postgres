# US-APMG-036 — Generated integer primary keys use bigserial

As a developer, I need generated integer migrations to preserve the selected sequence and identity contract.

Given a real generated integer primary key without an explicit default,

When the actual initial migration is read,

Then the id column is generated as bigserial.

Owning case: `test/migration_generator_generated_integer_test.exs`, story tag `US-APMG-036`.

Status: source migrated; executable verification pending.
