# US-APMG-004 — Timestamptz resources expose the native Ecto type

As a developer, I need the compiled resource's Ecto type to match its repository's timestamptz setting.

Given a real resource using a repository that enables timestamptz,

When its starts_at Ecto schema type is inspected,

Then it is the native parameterized AshPostgres.Timestamptz.EctoType with second precision, start-of-day date casting and UTC timezone.

Owning case: `test/migration_generator_timestamptz_test.exs`, story tag `US-APMG-004`.

Status: source migrated; executable verification pending.
