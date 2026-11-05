# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorEmptyResourcesTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule EmptyPost do
    use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: nil

    resource do
      require_primary_key?(false)
    end

    postgres do
      table "empty_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:read, :create])
    end
  end

  defmodule PostWithId do
    use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: nil

    postgres do
      table "posts_with_id"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule EmptyDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorEmptyResourcesTest.EmptyPost)
    end
  end

  defmodule PrimaryKeyDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorEmptyResourcesTest.PostWithId)
    end
  end

  @tag story: "US-APMG-001"
  test "empty resource does not generate migration files", %{tmp_dir: tmp_dir} do
    # Given a real resource without attributes or a required primary key.
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    # When native generation runs with case-owned output paths.
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(EmptyDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: false,
        format: false,
        auto_name: true
      )
    end)

    # Then it writes no resource migration or snapshot.
    migration_files =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))

    assert migration_files == []

    snapshot_files =
      Path.wildcard("#{snapshot_path}/**/*.json")
      |> Enum.reject(&String.contains?(&1, "extensions"))

    assert snapshot_files == []
  end

  @tag story: "US-APMG-002"
  test "resource with only primary key generates migration", %{tmp_dir: tmp_dir} do
    # Given a real resource whose only attribute is its primary key.
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    # When native generation runs with case-owned output paths.
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(PrimaryKeyDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: false,
        format: false,
        auto_name: true
      )
    end)

    # Then it writes one resource migration and one snapshot.
    migration_files =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))

    assert length(migration_files) == 1

    snapshot_files =
      Path.wildcard("#{snapshot_path}/**/*.json")
      |> Enum.reject(&String.contains?(&1, "extensions"))

    assert length(snapshot_files) == 1
  end
end
