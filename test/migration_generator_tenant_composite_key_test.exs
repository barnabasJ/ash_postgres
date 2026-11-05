# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorTenantCompositeKeyTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Version1Post do
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
      schema("example")
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true, allow_nil?: false)
    end

    multitenancy do
      strategy(:context)
    end
  end

  defmodule Version1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTenantCompositeKeyTest.Version1Post)
    end
  end

  defmodule Version2Post do
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
      schema("example")
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true, primary_key?: true, allow_nil?: false)
    end

    multitenancy do
      strategy(:context)
    end
  end

  defmodule Version2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTenantCompositeKeyTest.Version2Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")
    tenant_migration_path = Path.join(tmp_dir, "tenant_migrations")

    %{
      snapshot_path: snapshot_path,
      migration_path: migration_path,
      tenant_migration_path: tenant_migration_path
    }
  end

  @tag story: "US-APMG-038"
  test "create without composite key, then add extra key", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path,
    tenant_migration_path: tenant_migration_path
  } do
    # Given actual generation state and immutable schema-qualified resource versions.
    # When native generation consumes the persisted history and authored prompt answers.
    # Then the original tenant, rename and SQL-order contracts remain intact.

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Version1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        tenant_migration_path: tenant_migration_path,
        quiet: false,
        format: false,
        auto_name: true
      )
    end)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Version2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        tenant_migration_path: tenant_migration_path,
        quiet: false,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{tenant_migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file2)

    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    assert up_side =~
             ~S[execute("ALTER TABLE \"#{prefix()}\".\"posts\" ADD PRIMARY KEY (id, title)")]

    assert down_side =~
             ~S[execute("ALTER TABLE \"#{prefix()}\".\"posts\" ADD PRIMARY KEY (id)")]
  end
end
