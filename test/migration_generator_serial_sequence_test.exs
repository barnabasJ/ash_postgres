# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorSerialSequenceTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule SerialPost do
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
      attribute(:id, :integer,
        generated?: true,
        allow_nil?: false,
        primary_key?: true,
        public?: true,
        default: nil
      )
    end
  end

  defmodule SerialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSerialSequenceTest.SerialPost)
    end
  end

  defmodule DefaultPost do
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
      attribute(:id, :integer,
        generated?: true,
        allow_nil?: false,
        primary_key?: true,
        public?: true,
        default: 0
      )
    end
  end

  defmodule DefaultDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSerialSequenceTest.DefaultPost)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @spec generate_post_migration(
          domain :: module(),
          snapshot_path :: String.t(),
          migration_path :: String.t()
        ) :: String.t()
  defp generate_post_migration(domain, snapshot_path, migration_path) do
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)
  end

  @spec position_of_substring(string :: String.t(), substring :: String.t()) ::
          non_neg_integer() | nil
  defp position_of_substring(string, substring) do
    case :binary.match(string, substring) do
      {position, _length} -> position
      :nomatch -> nil
    end
  end

  @tag story: "US-APMG-034"
  test "removes the sequence when a generated integer stops being serial", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual initial files from a generated integer with a serial default.
    generate_post_migration(SerialDomain, snapshot_path, migration_path)

    # When native generation compares the immutable explicit-default version.
    generate_post_migration(DefaultDomain, snapshot_path, migration_path)

    # Then forward and reverse sequence operations retain their required SQL and ordering.
    assert [_initial_migration, alter_migration] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()

    migration = File.read!(alter_migration)

    assert migration =~ ~S[modify :id, :bigint, default: 0]
    assert migration =~ ~S[format('%I.%I', 'public', 'posts')]
    assert migration =~ ~S[pg_get_serial_sequence(]
    assert migration =~ ~S[DROP SEQUENCE %s]
    assert migration =~ ~S[CREATE SEQUENCE %s AS bigint]
    refute migration =~ ~S[modify :id, :bigserial]

    [up, down] = String.split(migration, "def down", parts: 2)

    assert position_of_substring(up, ~S[modify :id, :bigint, default: 0]) <
             position_of_substring(up, ~S[DROP SEQUENCE %s])

    assert position_of_substring(down, ~S[CREATE SEQUENCE %s AS bigint]) <
             position_of_substring(down, ~S[modify :id, :bigint])

    refute down =~ ~S[modify :id, :bigint, default: nil]
  end

  @tag story: "US-APMG-035"
  test "restores the sequence when a generated integer becomes serial", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual initial files from a generated integer with an explicit default.
    generate_post_migration(DefaultDomain, snapshot_path, migration_path)

    # When native generation compares the immutable serial-default version.
    generate_post_migration(SerialDomain, snapshot_path, migration_path)

    # Then forward and reverse sequence operations retain their required SQL and ordering.
    assert [_initial_migration, restore_sequence_migration] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()

    migration = File.read!(restore_sequence_migration)
    [up, down] = String.split(migration, "def down", parts: 2)

    assert position_of_substring(up, ~S[CREATE SEQUENCE %s AS bigint]) <
             position_of_substring(up, ~S[modify :id, :bigint])

    assert up =~ ~S[SET DEFAULT nextval]
    refute up =~ ~S[modify :id, :bigserial]
    refute up =~ ~S[modify :id, :bigint, default: nil]

    assert position_of_substring(down, ~S[modify :id, :bigint, default: 0]) <
             position_of_substring(down, ~S[DROP SEQUENCE %s])
  end
end
