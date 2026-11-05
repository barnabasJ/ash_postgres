# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeDropOptOutTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation
  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story022DeltaKeepMeV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_keep_me")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story022DeltaDroppableV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_droppable")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story022Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeDropOptOutTest.Story022DeltaKeepMeV1)
      resource(AshPostgres.DeltaModeDropOptOutTest.Story022DeltaDroppableV1)
    end
  end

  defmodule Story022Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeDropOptOutTest.Story022DeltaKeepMeV1)
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

  describe "drop table opt-out in delta mode" do
    @tag story: "US-APDI-022"
    test "answering 'no' to the drop prompt writes an OptOutDropTable delta", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      # We need at least one resource to remain so the generator walks the
      # orphan-detection path (it short-circuits when no resources are
      # produced at all).

      run_codegen(Story022Domain1, sp, mp)

      # Remove the droppable resource; keep the other.

      # Prompt: "Table delta_droppable no longer has a resource. Generate a
      # migration to DROP this table?" → answer "no".

      run_codegen(Story022Domain2, sp, mp, input: "n\n")

      files = delta_files(sp, "delta_droppable")

      opt_outs =
        files
        |> Enum.flat_map(fn f -> read_delta(f).operations end)
        |> Enum.filter(&match?(%Operation.OptOutDropTable{}, &1))

      assert opt_outs != []

      state = reduce_dir(sp, "delta_droppable")
      assert state.drop_table_opted_out == true
    end
  end
end
