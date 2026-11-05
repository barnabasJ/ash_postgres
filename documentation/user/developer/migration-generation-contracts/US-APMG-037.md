# US-APMG-037 — Explicit identity migration types are preserved

As a developer, I need generated integer migrations to preserve the selected sequence and identity contract.

Given a real resource declaring identity migration types for its primary id and generated sequence_id,

When the actual initial migration is read,

Then id uses identity with primary-key and null constraints and sequence_id uses identity with null false.

Owning case: `test/migration_generator_identity_type_test.exs`, story tag `US-APMG-037`.

Status: source migrated; executable verification pending.
