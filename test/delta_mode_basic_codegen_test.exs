# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeBasicCodegenTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation
  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story003DeltaPostAV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_a")
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

  defmodule Story003Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBasicCodegenTest.Story003DeltaPostAV1)
    end
  end

  defmodule Story004DeltaPostBV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_b")
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

  defmodule Story004Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBasicCodegenTest.Story004DeltaPostBV1)
    end
  end

  defmodule Story004DeltaPostBV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_b")
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

  defmodule Story004Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBasicCodegenTest.Story004DeltaPostBV2)
    end
  end

  defmodule Story005DeltaPostCV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_c")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story005Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBasicCodegenTest.Story005DeltaPostCV1)
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

  describe "basic codegen" do
    @tag story: "US-APDI-003"
    test "initial codegen produces a v2 delta with CreateTable + AddAttribute ops", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story003Domain1, sp, mp)

      [delta_file] = delta_files(sp, "delta_posts_a")
      delta = read_delta(delta_file)

      assert delta.version == 2
      assert length(ops_of_type(delta, Operation.CreateTable)) == 1

      sources =
        delta
        |> ops_of_type(Operation.AddAttribute)
        |> Enum.map(& &1.attribute.source)

      assert :id in sources
      assert :title in sources
    end

    @tag story: "US-APDI-004"
    test "adding an attribute in a follow-up codegen produces a minimal delta", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story004Domain1, sp, mp)

      run_codegen(Story004Domain2, sp, mp)

      files = delta_files(sp, "delta_posts_b")
      assert length(files) == 2

      second = List.last(files) |> read_delta()
      adds = ops_of_type(second, Operation.AddAttribute)
      assert [%{attribute: %{source: :body}}] = adds
      # Shouldn't contain CreateTable in a follow-up
      assert ops_of_type(second, Operation.CreateTable) == []
    end

    @tag story: "US-APDI-005"
    test "codegen with no changes does not emit any new delta files", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story005Domain1, sp, mp)
      [_initial] = delta_files(sp, "delta_posts_c")

      # Second call with identical resource
      run_codegen(Story005Domain1, sp, mp)
      assert length(delta_files(sp, "delta_posts_c")) == 1
    end
  end
end
