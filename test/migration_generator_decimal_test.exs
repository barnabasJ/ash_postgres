# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorDecimalTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1ProductVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)

      attribute(:price, :decimal,
        constraints: [precision: 10, scale: 2],
        public?: true,
        allow_nil?: false
      )

      attribute(:weight, :decimal,
        constraints: [precision: 8],
        public?: true,
        allow_nil?: false
      )

      attribute(:rating, :decimal, public?: true, allow_nil?: false)
    end
  end

  defmodule Scenario1Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario1ProductVersion1)
    end
  end

  defmodule Scenario2ProductVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:price, :decimal, constraints: [precision: 8, scale: 2], public?: true)
    end
  end

  defmodule Scenario2Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario2ProductVersion1)
    end
  end

  defmodule Scenario2ProductVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:price, :decimal, constraints: [precision: 12, scale: 4], public?: true)
    end
  end

  defmodule Scenario2Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario2ProductVersion2)
    end
  end

  defmodule Scenario3ProductVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)

      attribute(:price, :decimal,
        constraints: [precision: :arbitrary, scale: :arbitrary],
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Scenario3Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario3ProductVersion1)
    end
  end

  defmodule Scenario4ProductVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)

      attribute(:price, :decimal,
        constraints: [precision: 10, scale: 2],
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Scenario4Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario4ProductVersion1)
    end
  end

  defmodule Scenario4ProductVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)

      attribute(:price, :decimal,
        constraints: [precision: :arbitrary, scale: :arbitrary],
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Scenario4Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario4ProductVersion2)
    end
  end

  defmodule Scenario5CategoryVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "categories"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      attribute(:id, :decimal,
        constraints: [precision: 10, scale: 0],
        primary_key?: true,
        allow_nil?: false,
        public?: true
      )

      attribute(:name, :string, public?: true)
    end
  end

  defmodule Scenario5ProductVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "products"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)

      attribute(:category_id, :decimal,
        constraints: [precision: 10, scale: 0],
        allow_nil?: false,
        public?: true
      )
    end

    relationships do
      belongs_to(
        :category,
        AshPostgres.MigrationGeneratorDecimalTest.Scenario5CategoryVersion1
      ) do
        source_attribute(:category_id)
        destination_attribute(:id)
        public?(true)
      end
    end
  end

  defmodule Scenario5Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario5CategoryVersion1)
      resource(AshPostgres.MigrationGeneratorDecimalTest.Scenario5ProductVersion1)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-050"
  test "creates decimal columns with precision and scale", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable decimal resources and case-owned generated snapshot history.
    # When native generation writes the actual schema change.
    # Then the original precision, scale, FK and reverse SQL assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_content = File.read!(file)

    # Check that precision and scale are included for the price field
    assert file_content =~ ~S[add :price, :decimal, null: false, precision: 10, scale: 2]

    # Check that only precision is included for the weight field
    assert file_content =~ ~S[add :weight, :decimal, null: false, precision: 8]

    # Check that no precision or scale is included for the rating field
    assert file_content =~ ~S[add :rating, :decimal, null: false]
  end

  @tag story: "US-APMG-051"
  test "alters decimal columns with precision and scale changes", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable decimal resources and case-owned generated snapshot history.
    # When native generation writes the actual schema change.
    # Then the original precision, scale, FK and reverse SQL assertions remain intact.

    # Generate initial migration
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Now update the precision and scale

    # Generate follow-up migration
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    migration_files =
      Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
      |> Enum.reject(&String.contains?(&1, "extensions"))

    assert length(migration_files) == 2

    # Check the second migration file
    second_migration = File.read!(Enum.at(migration_files, 1))

    # Should contain the alter statement with new precision and scale
    assert second_migration =~ ~S[modify :price, :decimal, precision: 12, scale: 4]
  end

  @tag story: "US-APMG-052"
  test "handles arbitrary precision and scale constraints", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable decimal resources and case-owned generated snapshot history.
    # When native generation writes the actual schema change.
    # Then the original precision, scale, FK and reverse SQL assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario3Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_content = File.read!(file)

    # Check that no precision or scale is included when they are :arbitrary
    assert file_content =~ ~S[add :price, :decimal, null: false]
    refute file_content =~ ~S[precision:]
    refute file_content =~ ~S[scale:]
  end

  @tag story: "US-APMG-053"
  test "removes precision and scale when changing to arbitrary", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable decimal resources and case-owned generated snapshot history.
    # When native generation writes the actual schema change.
    # Then the original precision, scale, FK and reverse SQL assertions remain intact.

    # Generate initial migration
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Now change to arbitrary precision and scale

    # Generate follow-up migration
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Stage2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    migration_files =
      Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
      |> Enum.reject(&String.contains?(&1, "extensions"))

    assert length(migration_files) == 2

    # Check the second migration file
    second_migration = File.read!(Enum.at(migration_files, 1))

    [up, _down] = String.split(second_migration, "def down")

    # Should contain the alter statement removing precision and scale
    assert up =~ ~S[modify :price, :decimal]
    refute up =~ ~S[precision:]
    refute up =~ ~S[scale:]
  end

  @tag story: "US-APMG-054"
  test "works with decimal references that have precision and scale", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable decimal resources and case-owned generated snapshot history.
    # When native generation writes the actual schema change.
    # Then the original precision, scale, FK and reverse SQL assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario5Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_content = File.read!(file)

    # Check that both tables are created with proper decimal precision
    assert file_content =~
             ~S[add :id, :decimal, null: false, precision: 10, scale: 0, primary_key: true]

    # `category_id` is a new column with its foreign key known from the
    # start, so it's emitted as a single `add ..., references(...)` (rather
    # than a separate `add` followed by a later `modify ... references(...)`)
    # — this still carries the same decimal precision/scale.
    assert file_content =~
             ~S[add :category_id, references(:categories, column: :id, name: "products_category_id_fkey", type: :decimal, prefix: "public"), precision: 10, scale: 0, null: false]
  end
end
