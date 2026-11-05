# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeStructuralChangesTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation
  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story006DeltaPostDV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_d")
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

  defmodule Story006Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story006DeltaPostDV1)
    end
  end

  defmodule Story006DeltaPostDV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_d")
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

  defmodule Story006Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story006DeltaPostDV2)
    end
  end

  defmodule Story007DeltaPostEV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_e")
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

  defmodule Story007Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story007DeltaPostEV1)
    end
  end

  defmodule Story007DeltaPostEV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_e")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Story007Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story007DeltaPostEV2)
    end
  end

  defmodule Story008DeltaPostFV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_f")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true, allow_nil?: true)
    end
  end

  defmodule Story008Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story008DeltaPostFV1)
    end
  end

  defmodule Story008DeltaPostFV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_f")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true, allow_nil?: false)
    end
  end

  defmodule Story008Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story008DeltaPostFV2)
    end
  end

  defmodule Story009DeltaPostGV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_g_old")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story009Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story009DeltaPostGV1)
    end
  end

  defmodule Story009DeltaPostGV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_g_new")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story009Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story009DeltaPostGV2)
    end
  end

  defmodule Story010DeltaRenameRegenV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_rename_regen_old")
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

  defmodule Story010Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story010DeltaRenameRegenV1)
    end
  end

  defmodule Story010DeltaRenameRegenV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_rename_regen_new")
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

  defmodule Story010Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story010DeltaRenameRegenV2)
    end
  end

  defmodule Story010DeltaRenameRegenV3 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_rename_regen_new")
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

  defmodule Story010Domain3 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeStructuralChangesTest.Story010DeltaRenameRegenV3)
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

  describe "structural changes" do
    @tag story: "US-APDI-006"
    test "removing an attribute produces a RemoveAttribute op that reduces correctly", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story006Domain1, sp, mp)

      # Remove :body

      run_codegen(Story006Domain2, sp, mp)

      second = delta_files(sp, "delta_posts_d") |> List.last() |> read_delta()
      removes = ops_of_type(second, Operation.RemoveAttribute)
      assert [%{attribute: %{source: :body}}] = removes

      # Reduced state: :body gone, :id + :title remain
      state = reduce_dir(sp, "delta_posts_d")
      sources = Enum.map(state.attributes, & &1.source)
      assert :id in sources
      assert :title in sources
      refute :body in sources
    end

    @tag story: "US-APDI-007"
    test "renaming an attribute produces a RenameAttribute op", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story007Domain1, sp, mp)

      # "Yes" to "Are you renaming :title to :name?"
      run_codegen(Story007Domain2, sp, mp, input: "y\n")

      second = delta_files(sp, "delta_posts_e") |> List.last() |> read_delta()
      renames = ops_of_type(second, Operation.RenameAttribute)
      assert [%{old_attribute: %{source: :title}, new_attribute: %{source: :name}}] = renames

      state = reduce_dir(sp, "delta_posts_e")
      sources = Enum.map(state.attributes, & &1.source)
      assert :name in sources
      refute :title in sources
    end

    @tag story: "US-APDI-008"
    test "altering an attribute (type change) produces an AlterAttribute op", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story008Domain1, sp, mp)

      run_codegen(Story008Domain2, sp, mp)

      second = delta_files(sp, "delta_posts_f") |> List.last() |> read_delta()
      alters = ops_of_type(second, Operation.AlterAttribute)

      assert Enum.any?(alters, fn op ->
               op.new_attribute.source == :title and op.new_attribute.allow_nil? == false
             end)
    end

    @tag story: "US-APDI-009"
    test "renaming a table produces a RenameTable op", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story009Domain1, sp, mp)

      # First prompt: "Are you renaming delta_posts_g_old to delta_posts_g_new?"
      run_codegen(Story009Domain2, sp, mp, input: "y\n")

      # The rename is emitted against the NEW table directory, with ops
      # containing a RenameTable for old→new.
      new_files = delta_files(sp, "delta_posts_g_new")
      assert new_files != []

      all_ops =
        new_files
        |> Enum.flat_map(fn f -> read_delta(f).operations end)

      renames = Enum.filter(all_ops, &match?(%Operation.RenameTable{}, &1))

      assert Enum.any?(renames, fn op ->
               op.old_table == "delta_posts_g_old" and op.table == "delta_posts_g_new"
             end)
    end

    @tag story: "US-APDI-010"
    test "renaming a table, reducing, and generating a follow-up delta succeeds", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      # Regression test: the previous `test "renaming a table produces a
      # RenameTable op"` only asserts the op is written into the new dir. It
      # never reduces that dir afterwards. Today, reducing fails because the
      # initial deltas stayed in the OLD dir, so the new dir starts from
      # `empty_state` with table=new but the first op it sees is
      # RenameTable{old, new} — state.table ≠ op.old_table → ConflictError.
      #
      # This test exercises the full lifecycle: rename → codegen with an
      # additional attribute → assert the reducer sees the combined state.

      run_codegen(Story010Domain1, sp, mp)

      # "Yes" to "Are you renaming delta_rename_regen_old to delta_rename_regen_new?"
      run_codegen(Story010Domain2, sp, mp, input: "y\n")

      # Now add a column. Codegen must reduce the existing deltas — which
      # today blows up in Reducer.apply_op(%Operation.RenameTable{}, state)
      # because state.table != op.old_table.

      run_codegen(Story010Domain3, sp, mp)

      state = reduce_dir(sp, "delta_rename_regen_new")
      sources = Enum.map(state.attributes, & &1.source)
      assert :id in sources
      assert :title in sources
      assert :body in sources
      assert state.table == "delta_rename_regen_new"
    end
  end
end
