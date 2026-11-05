# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeDevTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.Operation.Codec
  alias AshPostgres.MigrationGenerator.Reducer
  @moduletag :migration
  @moduletag :tmp_dir
  @mt %{strategy: nil, attribute: nil, global: nil}

  defmodule Story035DeltaDevThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_dev_thing")
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

  defmodule Story035Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeDevTest.Story035DeltaDevThingV1)
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

  describe "--dev flag" do
    @tag story: "US-APDI-035"
    test "delta codegen with dev: true writes _dev.json files", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story035Domain1, sp, mp, dev: true)

      files = Path.wildcard("#{sp}/**/delta_dev_thing/*.json")
      assert length(files) == 1

      [file] = files
      assert String.ends_with?(file, "_dev.json")

      # The _dev delta is still a valid v2 delta.
      assert Codec.delta?(File.read!(file))

      # Reducer in dev mode loads it.
      snapshot = %{
        table: "delta_dev_thing",
        schema: nil,
        repo: AshPostgres.TestRepo,
        multitenancy: @mt
      }

      opts = %MigrationGenerator{snapshot_path: sp, dev: true, quiet: true}
      state = Reducer.load_reduced_state(snapshot, opts)

      assert Enum.any?(state.attributes, &(&1.source == :name))

      # Reducer in non-dev mode ignores the _dev file.
      opts_non_dev = %{opts | dev: false}
      assert Reducer.load_reduced_state(snapshot, opts_non_dev) == nil
    end
  end
end
