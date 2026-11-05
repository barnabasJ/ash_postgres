# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorCreateTableOptionsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1Post do
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
      table "posts"
      create_table_options("PARTITION BY RANGE (id)")
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      create_timestamp(:inserted_at)
    end
  end

  defmodule Scenario1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCreateTableOptionsTest.Scenario1Post)
    end
  end

  defmodule Scenario2Post do
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
      table "posts"
      create_table_options("PARTITION BY RANGE (id)")
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:user_id, :integer, public?: true)
    end

    multitenancy do
      strategy(:context)
    end
  end

  defmodule Scenario2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCreateTableOptionsTest.Scenario2Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations"),
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations")
    }
  end

  @tag story: "US-APMG-048"
  test "includes create_table_options in regular table migration", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given a real immutable resource and case-owned output paths.
    # When native generation writes its actual migration.
    # Then the declared defaults or table options remain present in generated SQL.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_contents = File.read!(file)

    assert file_contents =~
             ~S[create table(:posts, primary_key: false, options: "PARTITION BY RANGE (id)") do]
  end

  @tag story: "US-APMG-049"
  test "includes create_table_options in context-based multitenancy migration", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path,
    tenant_migration_path: tenant_migration_path
  } do
    # Given a real immutable resource and case-owned output paths.
    # When native generation writes its actual migration.
    # Then the declared defaults or table options remain present in generated SQL.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        tenant_migration_path: tenant_migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{tenant_migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_contents = File.read!(file)

    assert file_contents =~
             ~S[create table(:posts, primary_key: false, prefix: prefix(), options: "PARTITION BY RANGE (id)") do]
  end
end
