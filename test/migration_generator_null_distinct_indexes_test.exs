# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorNullDistinctIndexesTest do
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
        index([:uniq_one], nulls_distinct: true)
        index([:uniq_two], nulls_distinct: false)
        index([:uniq_custom_one])
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
      resource(AshPostgres.MigrationGeneratorNullDistinctIndexesTest.Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-012"
  test "it adds nulls_distinct option to create index migration", %{
    migration_path: migration_path
  } do
    # Given a real indexed resource and its case-owned generated migration.
    # When the native generated SQL is read.
    # Then the declared index options remain intact.
    assert [custom_index_migration] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file = File.read!(custom_index_migration)

    assert file =~ ~S<create index(:posts, [:uniq_one])>
    assert file =~ ~S<create index(:posts, [:uniq_two], nulls_distinct: false)>
    assert file =~ ~S<create index(:posts, [:uniq_custom_one])>
  end
end
