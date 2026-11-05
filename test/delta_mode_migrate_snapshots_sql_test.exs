# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeMigrateSnapshotsSQLTest do
  use AshPostgres.RepoCase, async: true
  import AshPostgres.Test.DeltaModeHelpers

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story024DeltaMigrateIncrV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrate_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Story024Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsSQLTest.Story024DeltaMigrateIncrV1)
    end
  end

  defmodule Story024DeltaMigrateIncrV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrate_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story024Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsSQLTest.Story024DeltaMigrateIncrV2)
    end
  end

  defmodule Story024DeltaMigrateIncrV3 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrate_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
      attribute(:tags, :string, public?: true)
    end
  end

  defmodule Story024Domain3 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsSQLTest.Story024DeltaMigrateIncrV3)
    end
  end

  defmodule Story024DeltaMigrateIncrV4 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrate_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Story024Domain4 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsSQLTest.Story024DeltaMigrateIncrV4)
    end
  end

  defmodule Story024DeltaMigrateIncrV5 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrate_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story024Domain5 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsSQLTest.Story024DeltaMigrateIncrV5)
    end
  end

  defmodule Story024DeltaMigrateIncrV6 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrate_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
      attribute(:tags, :string, public?: true)
    end
  end

  defmodule Story024Domain6 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsSQLTest.Story024DeltaMigrateIncrV6)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations"),
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations"),
      full_sp: Path.join(tmp_dir, "full/snapshots"),
      full_mp: Path.join(tmp_dir, "full/migrations"),
      delta_sp: Path.join(tmp_dir, "delta/snapshots"),
      delta_mp: Path.join(tmp_dir, "delta/migrations")
    }
  end

  describe "migrate_snapshots" do
    @tag story: "US-APDI-024"
    test "post-migrate incremental codegen emits the same migration as the no-migrate baseline",
         %{tmp_dir: tmp_dir} do
      # Two parallel timelines for an upgrade-path safety net:
      #   A) stays in :full mode the whole time and adds :tags
      #   B) does the same first two codegens in :full, then runs
      #      mix ash_postgres.migrate_snapshots, then adds :tags in :delta
      # The migration emitted for adding :tags must be identical between A
      # and B. Otherwise the migrate task is silently rewriting the diff
      # the user sees post-upgrade.
      sp_a = Path.join(tmp_dir, "no_migrate_sp")
      mp_a = Path.join(tmp_dir, "no_migrate_mp")
      sp_b = Path.join(tmp_dir, "with_migrate_sp")
      mp_b = Path.join(tmp_dir, "with_migrate_mp")

      tenant_a = Path.join(tmp_dir, "no_migrate_tenant")
      tenant_b = Path.join(tmp_dir, "with_migrate_tenant")

      # ---- Path A: stay in :full mode through all 3 codegens. ----

      generate(Story024Domain1,
        snapshot_path: sp_a,
        migration_path: mp_a,
        tenant_migration_path: tenant_a,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story024Domain2,
        snapshot_path: sp_a,
        migration_path: mp_a,
        tenant_migration_path: tenant_a,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story024Domain3,
        snapshot_path: sp_a,
        migration_path: mp_a,
        tenant_migration_path: tenant_a,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      # ---- Path B: same first two codegens, then migrate, then :delta. ----

      generate(Story024Domain4,
        snapshot_path: sp_b,
        migration_path: mp_b,
        tenant_migration_path: tenant_b,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story024Domain5,
        snapshot_path: sp_b,
        migration_path: mp_b,
        tenant_migration_path: tenant_b,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      # Migrate snapshots to v2.
      Mix.Tasks.AshPostgres.MigrateSnapshots.run(["--snapshot-path", sp_b, "--quiet"])

      generate(Story024Domain6,
        snapshot_path: sp_b,
        migration_path: mp_b,
        tenant_migration_path: tenant_b,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      # The third migration in each path is the "add tags" change. Their
      # bodies must match.
      [_, _, last_a] = migration_files(mp_a)
      [_, _, last_b] = migration_files(mp_b)

      a_body = migration_body_only(last_a)
      b_body = migration_body_only(last_b)

      assert a_body == b_body,
             "Post-migrate incremental migration diverged from the no-migrate baseline.\n\nA:\n#{a_body}\n\nB:\n#{b_body}"

      # Run both chains end-to-end and assert the resulting DB schema is
      # identical between the modes.
      migrations_mp_a = compile_migrations(mp_a)
      run_migrations(migrations_mp_a, :up)
      schema_a = capture_table_schema("delta_migrate_incr")
      run_migrations(migrations_mp_a, :down)

      migrations_mp_b = compile_migrations(mp_b)
      run_migrations(migrations_mp_b, :up)
      schema_b = capture_table_schema("delta_migrate_incr")
      run_migrations(migrations_mp_b, :down)

      assert schema_a == schema_b,
             "Post-migrate chain yielded a different DB schema than the no-migrate chain"
    end
  end
end
