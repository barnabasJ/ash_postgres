# US-APMG-017 — Same-name index replacements drop the prior index first

As a developer, I need an index predicate change to replace its existing index without a duplicate-name conflict.

Given a persisted initial title index and an immutable next-version resource whose title index has a non-null predicate,

When native generation compares the next version with the persisted snapshot,

Then both forward and reverse migrations drop the prior same-name index before creating its replacement, and the forward replacement contains the predicate.

Owning case: `test/migration_generator_index_evolution_test.exs`, story tag `US-APMG-017`.

Status: source migrated; executable verification pending.
