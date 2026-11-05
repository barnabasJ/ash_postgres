# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorSchemaRenamesTest do
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
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Version1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSchemaRenamesTest.Version1Post)
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
      attribute(:name, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule Version2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSchemaRenamesTest.Version2Post)
    end
  end

  defmodule Version3Post do
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
      attribute(:name, :string, allow_nil?: false, default: "fred", public?: true)
    end
  end

  defmodule Version3Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSchemaRenamesTest.Version3Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")
    tenant_migration_path = Path.join(tmp_dir, "tenant_migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Version1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{
      snapshot_path: snapshot_path,
      migration_path: migration_path,
      tenant_migration_path: tenant_migration_path
    }
  end

  @tag story: "US-APMG-039"
  test "when renaming a field, it asks if you are renaming it, and renames it if you are", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual generation state and immutable schema-qualified resource versions.
    # When native generation consumes the persisted history and authored prompt answers.
    # Then the original tenant, rename and SQL-order contracts remain intact.

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Version2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~ ~S[rename table(:posts, prefix: "example"), :title, to: :name]
  end

  @tag story: "US-APMG-040"
  test "renaming a field honors additional changes", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual generation state and immutable schema-qualified resource versions.
    # When native generation consumes the persisted history and authored prompt answers.
    # Then the original tenant, rename and SQL-order contracts remain intact.

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Version3Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file2)

    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    up_side_parts =
      String.split(up_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    up_rename_index =
      Enum.find_index(up_side_parts, fn x ->
        x == ~S[rename table(:posts, prefix: "example"), :title, to: :name]
      end)

    up_modify_index =
      Enum.find_index(up_side_parts, fn x ->
        x == ~S[modify :name, :text, null: false, default: "fred"]
      end)

    assert up_rename_index < up_modify_index

    down_side_parts =
      String.split(down_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    down_modify_index =
      Enum.find_index(down_side_parts, fn x ->
        x == ~S[modify :name, :text, null: true, default: nil]
      end)

    down_rename_index =
      Enum.find_index(down_side_parts, fn x ->
        x == ~S[rename table(:posts, prefix: "example"), :name, to: :title]
      end)

    assert down_modify_index < down_rename_index
  end
end
