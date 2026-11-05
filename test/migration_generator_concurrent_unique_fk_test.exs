# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorConcurrentUniqueFkTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule ConcurrentUniqueTarget do
    use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: nil

    postgres do
      table "concurrent_unique_targets"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:code, :string, allow_nil?: false, public?: true)
    end

    identities do
      identity(:uniq_code, [:code])
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule ConcurrentUniqueDependent do
    use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: nil

    postgres do
      table "concurrent_unique_dependents"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:target_code, :string, public?: true)
    end

    relationships do
      belongs_to(:target, ConcurrentUniqueTarget) do
        source_attribute(:target_code)
        destination_attribute(:code)
        attribute_writable?(true)
        allow_nil?(true)
        public?(true)
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule ConcurrentUniqueDomain do
    use Ash.Domain

    resources do
      resource(ConcurrentUniqueTarget)
      resource(ConcurrentUniqueDependent)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-014"
  test "dependent foreign keys are generated only after the unique index migration", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real static resources linked through a unique non-primary target.
    # When native generation splits concurrent index creation from FK creation.
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(ConcurrentUniqueDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        concurrent_indexes: true
      )
    end)

    assert [table_migration, unique_index_migration, fk_migration] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    table_contents = File.read!(table_migration)
    index_contents = File.read!(unique_index_migration)
    fk_contents = File.read!(fk_migration)

    # Three steps are generated:
    # 1. create tables without the FK to `:code`
    # 2. create the concurrent unique index on `concurrent_unique_targets.code`
    # 3. add the FK from `concurrent_unique_dependents.target_code`

    # Step 1: tables created, but target_code has no FK reference
    assert table_contents =~ ~S|create table(:concurrent_unique_targets|
    assert table_contents =~ ~S|create table(:concurrent_unique_dependents|
    refute table_contents =~ ~S|references(:concurrent_unique_targets|

    # Step 2: concurrent unique index (in a @disable_ddl_transaction migration)
    assert index_contents =~ ~S|@disable_ddl_transaction true|
    assert index_contents =~ ~S|@disable_migration_lock true|

    assert index_contents =~
             ~S|create unique_index(:concurrent_unique_targets, [:code], name: "concurrent_unique_targets_uniq_code_index", concurrently: true)|

    # Step 3: FK reference added
    assert fk_contents =~
             ~S|modify :target_code, references(:concurrent_unique_targets, column: :code, name: "concurrent_unique_dependents_target_code_fkey", type: :text, prefix: "public")|
  end
end
