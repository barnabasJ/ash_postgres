# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorIndexEvolutionTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule InitialPost do
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
        index([:title])
      end
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule InitialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorIndexEvolutionTest.InitialPost)
    end
  end

  defmodule RenamedPost do
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
        index([:title_short])
      end
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title_short, :string, public?: true)
    end
  end

  defmodule RenamedDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorIndexEvolutionTest.RenamedPost)
    end
  end

  defmodule PredicatePost do
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
        index([:title], where: "title IS NOT NULL")
      end
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule PredicateDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorIndexEvolutionTest.PredicatePost)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(InitialDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-016"
  test "it changes attribute and index in the correct order", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given initial files and an immutable next-version resource.
    # When native generation compares the persisted initial snapshot with that version.
    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(RenamedDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Then the generated forward and reverse operations preserve their required ordering.
    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file2)

    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    up_side_parts =
      String.split(up_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    assert Enum.find_index(up_side_parts, fn x ->
             x == "rename table(:posts), :title, to: :title_short"
           end) <
             Enum.find_index(up_side_parts, fn x ->
               x == "create index(:posts, [:title_short])"
             end)

    down_side_parts =
      String.split(down_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    assert Enum.find_index(down_side_parts, fn x ->
             x == "rename table(:posts), :title_short, to: :title"
           end) <
             Enum.find_index(down_side_parts, fn x -> x == "create index(:posts, [:title])" end)
  end

  @tag story: "US-APMG-017"
  test "it drops an unnamed index before recreating it under the same name", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given initial files and an immutable next-version resource.
    # When native generation compares the persisted initial snapshot with that version.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(PredicateDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Then the generated forward and reverse operations preserve their required ordering.
    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file2)

    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    up_side_parts =
      String.split(up_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    # both indexes are named posts_title_index, so the old one must go first
    assert Enum.find_index(up_side_parts, &(&1 == "drop_if_exists index(:posts, [:title])")) <
             Enum.find_index(
               up_side_parts,
               &(&1 == ~S{create index(:posts, [:title], where: "title IS NOT NULL")})
             )

    down_side_parts =
      String.split(down_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    assert Enum.find_index(down_side_parts, &(&1 == "drop_if_exists index(:posts, [:title])")) <
             Enum.find_index(down_side_parts, &(&1 == "create index(:posts, [:title])"))
  end
end
