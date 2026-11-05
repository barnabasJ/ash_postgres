# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorConstraintColumnRemovalTest do
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
      attribute(:price, :integer, public?: true)
    end

    postgres do
      check_constraints do
        check_constraint(:price, "price_must_be_positive", check: ~S["price" > 0])
      end
    end
  end

  defmodule Version1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorConstraintColumnRemovalTest.Version1Post)
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
    end
  end

  defmodule Version2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorConstraintColumnRemovalTest.Version2Post)
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

  @tag story: "US-APMG-018"
  test "the constraint is dropped before the column, so `down` recreates the column before the constraint",
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

    # up: drop the constraint before removing the column it covers.
    assert Enum.find_index(
             up_side_parts,
             &(&1 == "drop_if_exists constraint(:posts, :price_must_be_positive)")
           ) <
             Enum.find_index(up_side_parts, &(&1 == "remove :price"))

    down_side_parts = String.split(down_side, "\n", trim: true) |> Enum.map(&String.trim/1)

    # down (reversed): recreate the column before recreating the
    # constraint that references it — otherwise this `down` would fail
    # against real Postgres with "column price does not exist".
    assert Enum.find_index(down_side_parts, &(&1 == "add :price, :bigint")) <
             Enum.find_index(
               down_side_parts,
               &String.starts_with?(&1, "create constraint(:posts, :price_must_be_positive")
             )
  end
end
