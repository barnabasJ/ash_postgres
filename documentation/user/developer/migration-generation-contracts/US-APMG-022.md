# US-APMG-022 — Identity index names can change without replacement

As a developer, I need identity index name changes to generate the intended SQL rename.

Given an initial title identity and a next resource with an explicit new index name,

When native generation compares the resource with the persisted initial snapshot,

Then the migration contains ALTER INDEX posts_title_index RENAME TO titles_r_unique_dawg.

Owning case: `test/migration_generator_follow_up_test.exs`, story tag `US-APMG-022`.

Status: source migrated; executable verification pending.
