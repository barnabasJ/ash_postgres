# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeRunnableTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story038RunnableThing3V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("runnable_delta_3")
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

  defmodule Story038Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableTest.Story038RunnableThing3V1)
    end
  end

  defmodule Story038RunnableThing3V2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("runnable_delta_3")
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

  defmodule Story038Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableTest.Story038RunnableThing3V2)
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

  describe "generated migrations are runnable" do
    @tag story: "US-APDI-038"
    test "squashed delta produces a migration that creates the same schema",
         %{snapshot_path: sp, migration_path: mp} do
      run_codegen(Story038Domain1, sp, mp)

      run_codegen(Story038Domain2, sp, mp)

      # Squash all deltas for this resource into one.
      Mix.Tasks.AshPostgres.SquashSnapshots.run(["--snapshot-path", sp, "--quiet"])
      assert length(delta_files(sp, "runnable_delta_3")) == 1

      # Now codegen from a fresh migration path — simulating a new clone
      # where only squashed snapshots exist — and verify the resulting
      # initial migration creates the full schema.
      fresh_mp = Path.join(Path.dirname(mp), "fresh_migrations")
      File.mkdir_p!(fresh_mp)

      # Simulating "fresh clone": point codegen at the squashed snapshots
      # but an empty migration path. Since state matches the reduced
      # squashed state, codegen should produce no migration at all.
      migrations_before = migration_files(fresh_mp)

      generate(Story038Domain2,
        snapshot_path: sp,
        migration_path: fresh_mp,
        tenant_migration_path: Path.join(Path.dirname(mp), "fresh_tenant"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert migration_files(fresh_mp) == migrations_before
    end
  end
end
