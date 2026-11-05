# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeSquashTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story020DeltaSquashThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_thing")
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

  defmodule Story020Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashTest.Story020DeltaSquashThingV1)
    end
  end

  defmodule Story020DeltaSquashThingV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_thing")
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

  defmodule Story020Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashTest.Story020DeltaSquashThingV2)
    end
  end

  defmodule Story020DeltaSquashThingV3 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_thing")
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

  defmodule Story020Domain3 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashTest.Story020DeltaSquashThingV3)
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

  describe "squash in delta mode" do
    @tag story: "US-APDI-020"
    test "generate → squash → generate yields no drift", %{snapshot_path: sp, migration_path: mp} do
      run_codegen(Story020Domain1, sp, mp)

      # Two more changes → two more deltas

      run_codegen(Story020Domain2, sp, mp)

      run_codegen(Story020Domain3, sp, mp)

      files_before = delta_files(sp, "delta_squash_thing")
      assert length(files_before) == 3

      state_before = reduce_dir(sp, "delta_squash_thing")

      # Squash
      Mix.Tasks.AshPostgres.SquashSnapshots.run(["--snapshot-path", sp, "--quiet"])

      files_after = delta_files(sp, "delta_squash_thing")
      assert length(files_after) == 1

      state_after = reduce_dir(sp, "delta_squash_thing")

      # State preserved across the squash
      assert Enum.sort(Enum.map(state_before.attributes, & &1.source)) ==
               Enum.sort(Enum.map(state_after.attributes, & &1.source))

      # Codegen with unchanged resource should produce no new files or migrations
      migrations_before = migration_files(mp)

      run_codegen(Story020Domain3, sp, mp)

      assert delta_files(sp, "delta_squash_thing") == files_after
      assert migration_files(mp) == migrations_before
    end
  end
end
