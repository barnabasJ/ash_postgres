# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorNamedConcurrentIndexesTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Post do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

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

    postgres do
      custom_indexes do
        # need one without any opts
        index([:title], concurrently: true)
      end
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorNamedConcurrentIndexesTest.Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-015"
  test "it gives each generated migration a unique name and module", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given a concurrent index and an explicit migration name.
    # When native generation produces the split migrations.
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        name: "repro_case"
      )
    end)

    # Then their actual file names and module names are distinct.
    assert [first_migration, second_migration] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    first_contents = File.read!(first_migration)
    second_contents = File.read!(second_migration)

    first_name =
      first_migration
      |> Path.basename(".exs")
      |> then(&Regex.replace(~r/^\d+_/, &1, ""))

    second_name =
      second_migration
      |> Path.basename(".exs")
      |> then(&Regex.replace(~r/^\d+_/, &1, ""))

    assert [_, first_module] = Regex.run(~r/^defmodule\s+(.+)\s+do$/m, first_contents)
    assert [_, second_module] = Regex.run(~r/^defmodule\s+(.+)\s+do$/m, second_contents)

    # Split migrations still need unique derived names and modules, even
    # when the generation run uses an explicit `name`.
    assert first_name != second_name
    assert first_module != second_module
  end
end
