# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeMigrateSnapshotsTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation.Codec
  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story023DeltaMigratedV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_migrated")
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

  defmodule Story023Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMigrateSnapshotsTest.Story023DeltaMigratedV1)
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
    @tag story: "US-APDI-023"
    test "converting a legacy repo then running codegen in delta mode emits no migration",
         %{snapshot_path: sp, migration_path: mp} do
      # Step 1: generate in legacy full-state mode.

      generate(Story023Domain1,
        snapshot_path: sp,
        migration_path: mp,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      files = delta_files(sp, "delta_migrated")
      assert length(files) == 1
      refute Codec.delta?(File.read!(List.first(files)))

      migrations_before = migration_files(mp)

      # Step 2: migrate snapshots to v2.
      Mix.Tasks.AshPostgres.MigrateSnapshots.run(["--snapshot-path", sp, "--quiet"])

      post_migrate = delta_files(sp, "delta_migrated")
      assert length(post_migrate) == 1
      assert Codec.delta?(File.read!(List.first(post_migrate)))

      # Step 3: run codegen in delta mode with NO resource changes — should be a
      # no-op (no new deltas, no new migrations).
      run_codegen(Story023Domain1, sp, mp)

      assert delta_files(sp, "delta_migrated") == post_migrate
      assert migration_files(mp) == migrations_before
    end
  end
end
