# US-APMG-003 — Timestamptz selection preserves explicit type overrides

As a developer, I need repository timestamptz defaults to respect explicit migration types.

Given a real resource whose repository enables timestamptz and whose explicit_type attribute has a UTC datetime migration override,

When native migration generation writes the resource migration,

Then starts_at uses timestamptz and explicit_type retains utc_datetime.

Owning case: `test/migration_generator_timestamptz_test.exs`, story tag `US-APMG-003`.

Status: source migrated; executable verification pending.
