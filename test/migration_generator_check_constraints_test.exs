# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorCheckConstraintsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1PostVersion1 do
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
      attribute(:title, :string, public?: true)
    end

    postgres do
      check_constraints do
        check_constraint(:price, "price_must_be_positive", check: ~S["price" > 0])

        check_constraint(:title, "title_must_conform_to_format",
          check: ~S[title ~= '("\"\\"\\\"\\\\"\\\\\")']
        )
      end
    end
  end

  defmodule Scenario1Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario1PostVersion1)
    end
  end

  defmodule Scenario1PostVersion2 do
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
        check_constraint(:price, "price_must_be_positive", check: "price > 1")
      end
    end
  end

  defmodule Scenario1Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario1PostVersion2)
    end
  end

  defmodule Scenario2PostVersion1 do
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

    resource do
      base_filter(expr(price > 10))
    end

    postgres do
      base_filter_sql "price > -10"

      check_constraints do
        check_constraint(:price, "price_must_be_positive", check: "price > 0")
      end
    end
  end

  defmodule Scenario2Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario2PostVersion1)
    end
  end

  defmodule Scenario3PostVersion1 do
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
        check_constraint(:price, "price_must_be_positive", check: "price > 0")
      end
    end
  end

  defmodule Scenario3Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario3PostVersion1)
    end
  end

  defmodule Scenario3PostVersion2 do
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
  end

  defmodule Scenario3Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario3PostVersion2)
    end
  end

  defmodule Scenario4TextPostVersion1 do
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
      attribute(:kind, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    resource do
      base_filter(expr(kind == "text"))
    end

    postgres do
      base_filter_sql "kind = 'text'"

      check_constraints do
        check_constraint(:body, "text_has_body", message: "text notes need a body")
      end
    end
  end

  defmodule Scenario4PostVersion1 do
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
      attribute(:kind, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    postgres do
      check_constraints do
        check_constraint(:body, "text_has_body", check: "kind <> 'text' OR body IS NOT NULL")
      end
    end
  end

  defmodule Scenario4Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario4TextPostVersion1)
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario4PostVersion1)
    end
  end

  defmodule Scenario5TextPostVersion1 do
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
      attribute(:kind, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    resource do
      base_filter(expr(kind == "text"))
    end

    postgres do
      base_filter_sql "kind = 'text'"

      check_constraints do
        check_constraint(:body, "text_has_body", check: "kind <> 'text' OR body IS NOT NULL")
      end
    end
  end

  defmodule Scenario5PostVersion1 do
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
      attribute(:kind, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    postgres do
      check_constraints do
        check_constraint(:body, "text_has_body", check: "kind <> 'text' OR body IS NOT NULL")
      end
    end
  end

  defmodule Scenario5Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario5TextPostVersion1)
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario5PostVersion1)
    end
  end

  defmodule Scenario6TextPostVersion1 do
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
      attribute(:kind, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    resource do
      base_filter(expr(kind == "text"))
    end

    postgres do
      base_filter_sql "kind = 'text'"

      check_constraints do
        check_constraint(:body, "has_body", check: "body IS NOT NULL")
      end
    end
  end

  defmodule Scenario6FlagPostVersion1 do
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
      attribute(:kind, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    resource do
      base_filter(expr(kind == "flag"))
    end

    postgres do
      base_filter_sql "kind = 'flag'"

      check_constraints do
        check_constraint(:body, "has_body", check: "body IS NOT NULL")
      end
    end
  end

  defmodule Scenario6Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario6TextPostVersion1)
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario6FlagPostVersion1)
    end
  end

  defmodule Scenario7TextPostVersion1 do
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
      attribute(:body, :string, public?: true)
    end

    postgres do
      check_constraints do
        check_constraint(:body, "has_body", check: "body IS NOT NULL")
      end
    end
  end

  defmodule Scenario7PostVersion1 do
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
      attribute(:body, :string, public?: true)
    end

    postgres do
      check_constraints do
        check_constraint(:body, "has_body", check: "body <> ''")
      end
    end
  end

  defmodule Scenario7Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario7TextPostVersion1)
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario7PostVersion1)
    end
  end

  defmodule Scenario8PostVersion1 do
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
      base_filter_sql "price > -10"

      check_constraints do
        check_constraint(:price, "price_must_be_positive", check: "price > 0")
      end
    end
  end

  defmodule Scenario8Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario8PostVersion1)
    end
  end

  defmodule Scenario8PostVersion2 do
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
      base_filter_sql "price > -10"
    end
  end

  defmodule Scenario8Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario8PostVersion2)
    end
  end

  defmodule Scenario9PostVersion1 do
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
      base_filter_sql "price > -10"

      check_constraints do
        check_constraint(:price, "price_must_be_positive", check: "price > 0")
      end
    end
  end

  defmodule Scenario9Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckConstraintsTest.Scenario9PostVersion1)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-061"
  test "when added, the constraint is created", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(0)
             |> File.read!()

    assert file =~
             ~S'''
             create constraint(:posts, :price_must_be_positive, check: """
               "price" > 0
             """)
             '''

    assert file =~
             ~S'''
             create constraint(:posts, :title_must_conform_to_format, check: """
               title ~= '("\"\\"\\\"\\\\"\\\\\")'
             """)
             '''

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Stage2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(1)
             |> File.read!()

    assert [_, down] = String.split(file, "def down do")

    assert [_, remaining] =
             String.split(down, "drop_if_exists constraint(:posts, :price_must_be_positive)")

    assert remaining =~
             ~S'''
             create constraint(:posts, :price_must_be_positive, check: """
               "price" > 0
             """)
             '''
  end

  @tag story: "US-APMG-062"
  test "base filters are taken into account, negated", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(0)
             |> File.read!()

    assert file =~
             ~S'''
             create constraint(:posts, :price_must_be_positive, check: """
               (price > 0) OR NOT (price > -10)
             """)
             '''
  end

  @tag story: "US-APMG-063"
  test "when removed, the constraint is dropped before modification", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

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

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(1)

    assert File.read!(file) =~
             ~S[drop_if_exists constraint(:posts, :price_must_be_positive)]
  end

  @tag story: "US-APMG-064"
  test "when multiple resources share a table, a constraint named without `check` on the first resource does not drop the constraint",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.
    # The subtype only names the constraint (for the error mapping) and is declared first

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(0)
             |> File.read!()

    assert file =~
             ~S'''
             create constraint(:posts, :text_has_body, check: """
               kind <> 'text' OR body IS NOT NULL
             """)
             '''
  end

  @tag story: "US-APMG-065"
  test "when multiple resources share a table, a constraint defined without a base filter is not wrapped in another resource's base filter",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario5Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(0)
             |> File.read!()

    assert file =~
             ~S'''
             create constraint(:posts, :text_has_body, check: """
               kind <> 'text' OR body IS NOT NULL
             """)
             '''

    refute file =~ "OR NOT"
  end

  @tag story: "US-APMG-066"
  test "when multiple resources share a table and define the same constraint under different base filters, the base filters are combined",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario6Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(0)
             |> File.read!()

    assert file =~
             ~S'''
             create constraint(:posts, :has_body, check: """
               (body IS NOT NULL) OR NOT ((kind = 'text') OR (kind = 'flag'))
             """)
             '''
  end

  @tag story: "US-APMG-067"
  test "when multiple resources share a table and define conflicting checks under the same constraint name, it raises",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    assert_raise RuntimeError, ~r/conflicting check constraints named `has_body`/i, fn ->
      capture_io(fn ->
        AshPostgres.MigrationGenerator.generate(Scenario7Stage1Domain,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: true,
          format: false,
          auto_name: true
        )
      end)
    end
  end

  @tag story: "US-APMG-068"
  test "when a constraint with a base filter is removed, the down recreates it composed with the base filter",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario8Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario8Stage2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(1)
             |> File.read!()

    assert file =~ ~S[drop_if_exists constraint(:posts, :price_must_be_positive)]

    assert file =~
             ~S'''
             create constraint(:posts, :price_must_be_positive, check: """
               (price > 0) OR NOT (price > -10)
             """)
             '''

    refute file =~ "price > -10 AND price > 0"
  end

  @tag story: "US-APMG-069"
  test "when an existing snapshot has no base filter recorded on a constraint, it is not recreated",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given real immutable resource declarations and this case’s persisted snapshots.
    # When native generation processes the constraint change.
    # Then the original constraint SQL, composition and ordering assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario9Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Simulate a snapshot written before constraints recorded their base filter
    [snapshot_file] = Path.wildcard("#{snapshot_path}/**/posts/*.json")

    snapshot_file
    |> File.read!()
    |> Jason.decode!()
    |> Map.update!("check_constraints", fn constraints ->
      Enum.map(constraints, &Map.delete(&1, "base_filter"))
    end)
    |> Jason.encode!(pretty: true)
    |> then(&File.write!(snapshot_file, &1))

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario9Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_] =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
  end
end
