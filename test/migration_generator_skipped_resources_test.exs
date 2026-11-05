# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorSkippedResourcesTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule SkippedMigrateResource do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "skipped_migrate_resource"
      repo AshPostgres.TestRepo
      migrate? false
    end

    actions do
      defaults([:read, :create])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSkippedResourcesTest.SkippedMigrateResource)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-059"
  test "warns that resources were skipped due to migrate? false", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given a real resource excluded from migration generation.
    # When native generation runs twice against this case's persisted output.
    # Then the second run reports no changes and the actual skipped-resource warning.

    # First run: creates extension migrations (unrelated to our resource)
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: false,
        format: false,
        auto_name: true
      )
    end)

    # Second run: extensions already exist, so only the migrate? false
    # resource remains — which is skipped, producing "No changes detected"
    output =
      capture_io(fn ->
        AshPostgres.MigrationGenerator.generate(Domain,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: false,
          format: false,
          auto_name: true
        )
      end)

    assert output =~ "No changes detected"
    assert output =~ "Some resources have `migrate?` set to `false` and were skipped"
  end
end
