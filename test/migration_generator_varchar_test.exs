# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorVarcharTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1MyResourceVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blibs, :string, public?: true)
    end
  end

  defmodule Scenario1Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario1MyResourceVersion1)
    end
  end

  defmodule Scenario1MyResourceVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources"
      migration_types(blibs: {:varchar, 255})
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blibs, :string, public?: true)
    end
  end

  defmodule Scenario1Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario1MyResourceVersion2)
    end
  end

  defmodule Scenario2MyResourceVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources_varchar_change"
      migration_types(blibs: {:varchar, 100})
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blibs, :string, public?: true)
    end
  end

  defmodule Scenario2Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario2MyResourceVersion1)
    end
  end

  defmodule Scenario2MyResourceVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources_varchar_change"
      migration_types(blibs: {:varchar, 255})
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blibs, :string, public?: true)
    end
  end

  defmodule Scenario2Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario2MyResourceVersion2)
    end
  end

  defmodule Scenario3MyResourceVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources_binary"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blobs, :string, public?: true)
    end
  end

  defmodule Scenario3Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario3MyResourceVersion1)
    end
  end

  defmodule Scenario3MyResourceVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources_binary"
      migration_types(blobs: {:binary, 500})
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blobs, :string, public?: true)
    end
  end

  defmodule Scenario3Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario3MyResourceVersion2)
    end
  end

  defmodule Scenario4MyResourceVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources_multi"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blibs, :string, public?: true)
      attribute(:blobs, :string, public?: true)
    end
  end

  defmodule Scenario4Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario4MyResourceVersion1)
    end
  end

  defmodule Scenario4MyResourceVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "my_resources_multi"
      migration_types(blibs: {:varchar, 255})
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:blibs, :string, public?: true)
      attribute(:blobs, :string, public?: true)
    end
  end

  defmodule Scenario4Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorVarcharTest.Scenario4MyResourceVersion2)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-055"
  test "modify includes varchar size when adding migration_types to existing string column", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual stored snapshots and immutable string/binary resource versions.
    # When native generation compares their migration-type declarations.
    # Then the original size and unrelated-column assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Stage2Domain,
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

    second_migration = File.read!(file2)

    assert second_migration =~ ~S[modify :blibs, :varchar, size: 255]
    assert second_migration =~ ~S[modify :blibs, :text]
  end

  @tag story: "US-APMG-056"
  test "modify includes new size when changing from one varchar size to another", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual stored snapshots and immutable string/binary resource versions.
    # When native generation compares their migration-type declarations.
    # Then the original size and unrelated-column assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage2Domain,
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

    second_migration = File.read!(file2)

    assert second_migration =~ ~S[modify :blibs, :varchar, size: 255]
    assert second_migration =~ ~S[modify :blibs, :varchar, size: 100]
  end

  @tag story: "US-APMG-057"
  test "modify includes size when changing text to binary with migration_types", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual stored snapshots and immutable string/binary resource versions.
    # When native generation compares their migration-type declarations.
    # Then the original size and unrelated-column assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario3Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario3Stage2Domain,
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

    second_migration = File.read!(file2)

    assert second_migration =~ ~S[modify :blobs, :binary, size: 500]
    assert second_migration =~ ~S[modify :blobs, :text]
  end

  @tag story: "US-APMG-058"
  test "modify only affects attribute with migration_types when multiple string attributes exist",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    # Given actual stored snapshots and immutable string/binary resource versions.
    # When native generation compares their migration-type declarations.
    # Then the original size and unrelated-column assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Stage2Domain,
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

    second_migration = File.read!(file2)

    assert second_migration =~ ~S[modify :blibs, :varchar, size: 255]
    refute second_migration =~ ~S[modify :blobs]
  end
end
