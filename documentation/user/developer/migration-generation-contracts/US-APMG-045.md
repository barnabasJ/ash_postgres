# US-APMG-045 — Global context multitenancy preserves skipped foreign keys

As a developer, I need multitenancy capability changes to preserve valid existing schema state.

Given actual persisted private-context users and api_keys resources and a complete immutable next graph with a global context user,

When native generation compares both complete resource graphs through persisted tenant and global history,

Then neither initial nor follow-up SQL drops the api_keys_user_id_fkey constraint that was skipped by the multitenant configuration.

Owning case: `test/migration_generator_global_multitenancy_test.exs`, story tag `US-APMG-045`.

Status: source migrated; executable verification pending.
