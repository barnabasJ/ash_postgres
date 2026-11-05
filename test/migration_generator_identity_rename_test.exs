# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorIdentityRenameTest do
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

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    identities do
      identity(:uniq_title, [:title])
    end
  end

  defmodule Version1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorIdentityRenameTest.Version1Post)
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

    attributes do
      uuid_primary_key(:id)
      attribute(:title_short, :string, public?: true)
    end

    identities do
      identity(:uniq_title, [:title_short])
    end
  end

  defmodule Version2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorIdentityRenameTest.Version2Post)
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

  @tag story: "US-APMG-019"
  test "the old identity's index is dropped before the rename, so `down` recreates the index after undoing the rename",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
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

    up_side_parts = String.split(up_side, "\n", trim: true) |> Enum.map(&String.trim/1)

    assert Enum.find_index(
             up_side_parts,
             &(&1 == "rename table(:posts), :title, to: :title_short")
           ) <
             Enum.find_index(
               up_side_parts,
               &String.starts_with?(&1, "create unique_index(:posts, [:title_short]")
             )

    down_side_parts = String.split(down_side, "\n", trim: true) |> Enum.map(&String.trim/1)

    # down (reversed): undo the rename before recreating the old index —
    # otherwise this `down` would try to index a column name that doesn't
    # exist yet.
    assert Enum.find_index(
             down_side_parts,
             &(&1 == "rename table(:posts), :title_short, to: :title")
           ) <
             Enum.find_index(
               down_side_parts,
               &String.starts_with?(&1, "create unique_index(:posts, [:title]")
             )
  end
end
