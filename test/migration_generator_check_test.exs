# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorCheckTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule PendingPost do
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
  end

  defmodule PendingDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckTest.PendingPost)
    end
  end

  defmodule DevInitialPost do
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
      attribute(:old_a, :string, public?: true)
      attribute(:old_b, :string, public?: true)
      attribute(:old_c, :string, public?: true)
      attribute(:old_d, :string, public?: true)
    end
  end

  defmodule DevInitialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckTest.DevInitialPost)
    end
  end

  defmodule NextFieldsPost do
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
      attribute(:new_a, :string, public?: true)
      attribute(:new_b, :string, public?: true)
    end
  end

  defmodule NextFieldsDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckTest.NextFieldsPost)
    end
  end

  defmodule AmbiguousInitialPost do
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
      attribute(:old_a, :string, public?: true)
      attribute(:old_b, :string, public?: true)
    end
  end

  defmodule AmbiguousInitialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorCheckTest.AmbiguousInitialPost)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      domain: PendingDomain,
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-041"
  test "raises an error on pending codegen", %{
    domain: domain,
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable resources and this case’s own migration paths.
    # When the real generator checks actual pending changes.
    # Then the native error and file-state assertions retain their contract.
    assert_raise Ash.Error.Framework.PendingCodegen, fn ->
      AshPostgres.MigrationGenerator.generate(domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        check: true,
        auto_name: true
      )
    end

    assert Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs") == []
    assert Path.wildcard("#{snapshot_path}/test_repo/posts/*.json") == []
  end

  @tag story: "US-APMG-042"
  test "reports remaining dev migrations instead of inferring renames", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable resources and this case’s own migration paths.
    # When the real generator checks actual pending changes.
    # Then the native error and file-state assertions retain their contract.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(DevInitialDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        name: "initial_attributes"
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(NextFieldsDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        dev: true
      )
    end)

    dev_files = Path.wildcard(Path.join(migration_path, "*_dev.exs"))
    assert dev_files != []

    message =
      capture_io(:stderr, fn ->
        assert catch_exit(
                 AshPostgres.MigrationGenerator.generate(NextFieldsDomain,
                   snapshot_path: snapshot_path,
                   migration_path: migration_path,
                   check: true,
                   auto_name: true
                 )
               ) == {:shutdown, 1}
      end)

    assert Path.wildcard(Path.join(migration_path, "*_dev.exs")) == dev_files

    assert message =~ "You have migrations remaining that were generated with the --dev flag."
  end

  @tag story: "US-APMG-043"
  test "does not infer renames for ambiguous changes", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given immutable resources and this case’s own migration paths.
    # When the real generator checks actual pending changes.
    # Then the native error and file-state assertions retain their contract.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(AmbiguousInitialDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        name: "initial_attributes"
      )
    end)

    error =
      assert_raise Ash.Error.Framework.PendingCodegen, fn ->
        AshPostgres.MigrationGenerator.generate(NextFieldsDomain,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          check: true,
          auto_name: true
        )
      end

    refute Enum.any?(error.diff, fn {_path, contents} -> contents =~ "rename" end)
  end
end
