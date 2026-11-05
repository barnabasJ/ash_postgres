# US-APMG-006 — FK declaration order preserves table creation

As a developer, I need explicit foreign-key attributes to work before or after identity attributes in the resource declaration.

Given two real resources whose post_id foreign key appears on opposite sides of their unique title attribute,

When native snapshot generation and creation-operation generation run for each resource,

Then the snapshots retain their declared attribute order and both resources emit a table-creation phase.

Owning case: `test/migration_generator_fk_attribute_order_test.exs`, story tag `US-APMG-006`.

Status: source migrated; executable verification pending.
