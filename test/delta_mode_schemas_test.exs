# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeSchemasTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.Operation
  alias AshPostgres.MigrationGenerator.Reducer
  @moduletag :migration
  @moduletag :tmp_dir
  @mt %{strategy: nil, attribute: nil, global: nil}

  defmodule Story034DeltaSchemaThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_schema_thing")
      schema("example")
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

  defmodule Story034Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSchemasTest.Story034DeltaSchemaThingV1)
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

  describe "schema-prefixed tables" do
    @tag story: "US-APDI-034"
    test "delta files for a schema-prefixed resource land under {schema}.{table}/", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story034Domain1, sp, mp)

      # File should be at {sp}/test_repo/example.delta_schema_thing/*.json
      delta_path_glob = "#{sp}/**/example.delta_schema_thing/*.json"
      files = Path.wildcard(delta_path_glob)

      assert length(files) == 1

      delta = List.first(files) |> read_delta()

      create_table = Enum.find(delta.operations, &match?(%Operation.CreateTable{}, &1))
      assert create_table.schema == "example"
      assert create_table.table == "delta_schema_thing"

      # Reducer reads the schema-prefixed directory
      snapshot = %{
        table: "delta_schema_thing",
        schema: "example",
        repo: AshPostgres.TestRepo,
        multitenancy: @mt
      }

      opts = %MigrationGenerator{snapshot_path: sp, dev: false, quiet: true}
      state = Reducer.load_reduced_state(snapshot, opts)
      assert state.schema == "example"
      assert Enum.any?(state.attributes, &(&1.source == :id))
      assert Enum.any?(state.attributes, &(&1.source == :name))
    end
  end
end
