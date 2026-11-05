# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorGlobalMultitenancyTest do
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

    identities do
      identity(:title, [:title])
    end

    multitenancy do
      strategy(:attribute)
      attribute(:organization_id)
      global?(false)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:organization_id, :string)
    end
  end

  defmodule GlobalPost do
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

    identities do
      identity(:title, [:title])
    end

    multitenancy do
      strategy(:attribute)
      attribute(:organization_id)
      global?(true)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:organization_id, :string)
    end
  end

  defmodule PrivateUser do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    multitenancy do
      strategy(:context)
      global?(false)
    end
  end

  defmodule GlobalUser do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    multitenancy do
      strategy(:context)
      global?(true)
    end
  end

  defmodule PrivateApiKey do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "api_keys"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:user, AshPostgres.MigrationGeneratorGlobalMultitenancyTest.PrivateUser)
    end
  end

  defmodule GlobalApiKey do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "api_keys"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:user, AshPostgres.MigrationGeneratorGlobalMultitenancyTest.GlobalUser)
    end
  end

  defmodule InitialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.InitialPost)
    end
  end

  defmodule GlobalPostDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.GlobalPost)
    end
  end

  defmodule PrivateUserDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.InitialPost)
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.PrivateUser)
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.PrivateApiKey)
    end
  end

  defmodule GlobalUserDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.InitialPost)
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.GlobalUser)
      resource(AshPostgres.MigrationGeneratorGlobalMultitenancyTest.GlobalApiKey)
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

    %{
      snapshot_path: snapshot_path,
      migration_path: migration_path,
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations")
    }
  end

  @tag story: "US-APMG-044"
  test "when changing multitenancy to global, identities aren't rewritten", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual initial files and immutable tenant-capability resource graphs.
    # When native generation compares the complete next graph with its persisted history.
    # Then it preserves existing identities and avoids dropping skipped references.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(GlobalPostDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))
  end

  @tag story: "US-APMG-045"
  test "when changing a context multitenant resource to global, skipped references are not dropped",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path,
         tenant_migration_path: tenant_migration_path
       } do
    # Given actual initial files and immutable tenant-capability resource graphs.
    # When native generation compares the complete next graph with its persisted history.
    # Then it preserves existing identities and avoids dropping skipped references.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(PrivateUserDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        tenant_migration_path: tenant_migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert initial_migration =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> List.last()
             |> File.read!()

    refute initial_migration =~ ~S[drop constraint(:api_keys, "api_keys_user_id_fkey")]

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(GlobalUserDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        tenant_migration_path: tenant_migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert follow_up_migration =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> List.last()
             |> File.read!()

    refute follow_up_migration =~ ~S[drop constraint(:api_keys, "api_keys_user_id_fkey")]
  end
end
