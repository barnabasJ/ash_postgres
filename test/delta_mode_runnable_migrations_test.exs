# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeRunnableMigrationsTest do
  use AshPostgres.RepoCase, async: true

  import ExUnit.CaptureIO
  import AshPostgres.Test.DeltaModeHelpers

  alias AshPostgres.MigrationGenerator

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Initial do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("runnable_delta_1")
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

  defmodule BeforeColumn do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("runnable_delta_2")
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

  defmodule AfterColumn do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("runnable_delta_2")
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

  defmodule InitialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableMigrationsTest.Initial)
    end
  end

  defmodule BeforeColumnDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableMigrationsTest.BeforeColumn)
    end
  end

  defmodule AfterColumnDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableMigrationsTest.AfterColumn)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APDI-001"
  test "initial delta-mode codegen produces a migration that runs up-and-down cleanly",
       %{snapshot_path: sp, migration_path: mp} do
    generate(InitialDomain, sp, mp, "migrate_resources_apdi_001_initial")
    migrations = mp |> migration_files() |> Enum.map(&compile_migration/1)

    refute table_exists?("runnable_delta_1")
    run_migrations(migrations, :up)
    assert table_exists?("runnable_delta_1")
    assert column_exists?("runnable_delta_1", "id")
    assert column_exists?("runnable_delta_1", "title")
    assert column_exists?("runnable_delta_1", "body")

    run_migrations(migrations, :down)
    refute table_exists?("runnable_delta_1")
  end

  @tag story: "US-APDI-002"
  test "a second codegen (add column) produces a runnable migration",
       %{snapshot_path: sp, migration_path: mp} do
    generate(BeforeColumnDomain, sp, mp, "migrate_resources_apdi_002_initial")
    initial_files = migration_files(mp)
    initial = Enum.map(initial_files, &compile_migration/1)
    run_migrations(initial, :up)

    assert table_exists?("runnable_delta_2")
    assert column_exists?("runnable_delta_2", "title")
    refute column_exists?("runnable_delta_2", "body")

    generate(AfterColumnDomain, sp, mp, "migrate_resources_apdi_002_add_body")
    assert length(Path.wildcard("#{sp}/**/runnable_delta_2/*.json")) == 2
    added = (migration_files(mp) -- initial_files) |> Enum.map(&compile_migration/1)
    assert [_new_migration] = added
    migrations = initial ++ added

    run_migrations(migrations, :up)
    assert column_exists?("runnable_delta_2", "body")
    run_migrations(migrations, :down)
    refute table_exists?("runnable_delta_2")
  end

  @spec generate(domain :: module(), sp :: String.t(), mp :: String.t(), name :: String.t()) ::
          String.t()
  defp generate(domain, sp, mp, name) do
    capture_io(fn ->
      MigrationGenerator.generate(domain,
        snapshot_path: sp,
        migration_path: mp,
        tenant_migration_path: Path.join(Path.dirname(mp), "tenant_migrations"),
        quiet: true,
        format: false,
        name: name,
        snapshot_format: :delta
      )
    end)
  end
end
