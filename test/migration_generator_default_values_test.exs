# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorDefaultValuesTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO
  import ExUnit.CaptureLog

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1Post do
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
      attribute(:start_date, :date, default: ~D[2022-04-19], public?: true)
      attribute(:start_time, :time, default: ~T[08:30:45], public?: true)
      attribute(:timestamp, :utc_datetime, default: ~U[2022-02-02 08:30:30Z], public?: true)

      attribute(:timestamp_naive, :naive_datetime,
        default: ~N[2022-02-02 08:30:30],
        public?: true
      )

      attribute(:number, :integer, default: 5, public?: true)
      attribute(:fraction, :float, default: 0.25, public?: true)

      attribute(:decimal, :decimal,
        default: Decimal.new("123.4567890987654321987"),
        public?: true
      )

      attribute(:decimal_list, {:array, :decimal},
        default: [Decimal.new("123.4567890987654321987")],
        public?: true
      )

      attribute(:name, :string, default: "Fred", public?: true)
      attribute(:tag, :atom, default: :value, public?: true)
      attribute(:enabled, :boolean, default: false, public?: true)
    end
  end

  defmodule Scenario1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDefaultValuesTest.Scenario1Post)
    end
  end

  defmodule Scenario2Post do
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
      attribute(:product_code, :term, default: {"xyz"}, public?: true)
    end
  end

  defmodule Scenario2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorDefaultValuesTest.Scenario2Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations"),
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations")
    }
  end

  @tag story: "US-APMG-046"
  test "when default value is specified that implements EctoMigrationDefault", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given a real immutable resource and case-owned output paths.
    # When native generation writes its actual migration.
    # Then the declared defaults or table options remain present in generated SQL.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file1] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file = File.read!(file1)

    assert file =~
             ~S[add :start_date, :date, default: fragment("'2022-04-19'")]

    assert file =~
             ~S[add :start_time, :time, default: fragment("'08:30:45'")]

    assert file =~
             ~S[add :timestamp, :utc_datetime, default: fragment("'2022-02-02 08:30:30Z'")]

    assert file =~
             ~S[add :timestamp_naive, :naive_datetime, default: fragment("'2022-02-02 08:30:30'")]

    assert file =~
             ~S[add :number, :bigint, default: 5]

    assert file =~
             ~S[add :fraction, :float, default: 0.25]

    assert file =~
             ~S[add :decimal, :decimal, default: "123.4567890987654321987"]

    assert file =~
             ~S[add :name, :text, default: "Fred"]

    assert file =~
             ~S[add :tag, :text, default: "value"]

    assert file =~
             ~S[add :enabled, :boolean, default: false]
  end

  @tag story: "US-APMG-047"
  test "when default value is specified that does not implement EctoMigrationDefault", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given a real immutable resource and case-owned output paths.
    # When native generation writes its actual migration.
    # Then the declared defaults or table options remain present in generated SQL.

    log =
      capture_log(fn ->
        capture_io(fn ->
          AshPostgres.MigrationGenerator.generate(Scenario2Domain,
            snapshot_path: snapshot_path,
            migration_path: migration_path,
            quiet: true,
            format: false,
            auto_name: true
          )
        end)
      end)

    assert log =~ "`{\"xyz\"}`"

    assert [file1] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file = File.read!(file1)

    assert file =~
             ~S[add :product_code, :binary]
  end
end
