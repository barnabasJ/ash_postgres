# US-APMG-070 — Polymorphic references honor table context

As a developer, I need polymorphic relationship references to use their declared physical table.

Given a real polymorphic Comment resource and Post relationships whose data-layer context selects post_comments,

When native generation writes the actual graph migration,

Then the Post best_comment foreign key targets post_comments with the original column, constraint name, type and prefix.

Owning case: `test/migration_generator_polymorphic_test.exs`, story tag `US-APMG-070`.

Status: source migrated; executable verification pending.
