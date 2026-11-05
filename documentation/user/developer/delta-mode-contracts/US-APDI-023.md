# US-APDI-023 — converting a legacy repo then running codegen in delta mode emits no migration

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through migrate_snapshots.

## Scenario

Given a repository has a legacy full snapshot.
When the native migrate_snapshots task converts it and delta generation reruns unchanged.
Then the converted snapshot chain emits no migration.

Coverage: `US-APDI-023` in `test/delta_mode_migrate_snapshots_test.exs`.
