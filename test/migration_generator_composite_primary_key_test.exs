# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorCompositePrimaryKeyTest do
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
      attribute(:title, :string, public?: true, primary_key?: true, allow_nil?: false)
    end
  end

  defmodule Version1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCompositePrimaryKeyTest.Version1Post)
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
    end
  end

  defmodule Version2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCompositePrimaryKeyTest.Version2Post)
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
      attribute(:title, :string, public?: true, primary_key?: true, allow_nil?: false)
    end
  end

  defmodule Version3Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCompositePrimaryKeyTest.Version3Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Version1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-020"
  test "when removing an element, it recreates the primary key", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given persisted initial files and immutable resource versions for this migration.
    # When native generation compares each next version with its actual stored snapshot.
    # Then the generated forward and reverse SQL preserve the original ordering contract.

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

    contents = File.read!(file2)

    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    assert up_side =~ ~S[execute("ALTER TABLE \"example\".\"posts\" ADD PRIMARY KEY (id)")]

    assert down_side =~
             ~S[execute("ALTER TABLE \"example\".\"posts\" DROP constraint posts_pkey")]

    assert down_side =~
             ~S[execute("ALTER TABLE \"example\".\"posts\" ADD PRIMARY KEY (id, title)")]

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Version3Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, _file2, file3] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file3)

    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    assert up_side =~
             ~S[execute("ALTER TABLE \"example\".\"posts\" ADD PRIMARY KEY (id, title)")]

    assert down_side =~ ~S[execute("ALTER TABLE \"example\".\"posts\" ADD PRIMARY KEY (id)")]
  end
end
