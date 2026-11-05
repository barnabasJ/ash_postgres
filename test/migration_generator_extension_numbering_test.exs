# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorExtensionNumberingTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Post do
    use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: nil

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index ["id"]
        index ["id"], unique: true, name: "test_unique_index"
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorExtensionNumberingTest.Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")
    File.mkdir_p!(migration_path)

    File.write!(
      Path.join(migration_path, "20200101000000_migrate_resources_extensions_1.exs"),
      "# placeholder"
    )

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{migration_path: migration_path}
  end

  @tag story: "US-APMG-060"
  test "a new extensions migration increments past the existing one", %{
    migration_path: migration_path
  } do
    # Given the actual initial extension migration numbered one in this case's path.
    # When native generation writes the next extension migrations.
    # Then every generated extension file and module uses the next sequence number.
    # the test config shares one migration path across all test repos, so one
    # extensions migration is generated per repo. Each must be numbered past
    # the pre-existing `_1` rather than colliding with it.
    new_files =
      Path.wildcard("#{migration_path}/**/*_migrate_resources_extensions_*.exs")
      |> Enum.reject(&String.starts_with?(Path.basename(&1), "20200101000000_"))

    assert new_files != []

    for file <- new_files do
      assert Path.basename(file) =~ ~r/^\d+_migrate_resources_extensions_2\.exs$/
      assert File.read!(file) =~ "MigrateResourcesExtensions2 do"
    end
  end
end
