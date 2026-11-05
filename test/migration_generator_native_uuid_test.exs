# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorNativeUuidTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule TestRepo do
    use AshPostgres.Repo, otp_app: :ash_postgres

    @impl AshPostgres.Repo
    @spec installed_extensions() :: [String.t() | module()]
    def installed_extensions, do: AshPostgres.TestRepo.installed_extensions()

    @impl AshPostgres.Repo
    @spec min_pg_version() :: Version.t()
    def min_pg_version, do: %Version{major: 18, minor: 0, patch: 0}

    @impl AshPostgres.Repo
    @spec use_builtin_uuidv7_function?() :: boolean()
    def use_builtin_uuidv7_function?, do: true
  end

  defmodule Post do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.MigrationGeneratorNativeUuidTest.TestRepo

      custom_indexes do
        index ["id"]
        index ["id"], unique: true, name: "test_unique_index"
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_v7_primary_key(:id)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorNativeUuidTest.Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-007"
  test "the migration uses the native uuidv7 function", ctx do
    # Given a real repository that explicitly declares the PostgreSQL 18 UUID capability.
    # When its generated migration and persisted snapshot are read.
    assert File.read!(Path.wildcard("#{ctx.snapshot_path}/test_repo/posts/*.json"))
           |> Jason.decode!(keys: :atoms!)

    assert [file] =
             Path.wildcard("#{ctx.migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_contents = File.read!(file)

    # Then the native server default remains the primary-key default.
    assert file_contents =~
             ~S[add :id, :uuid, null: false, default: fragment("uuidv7()"), primary_key: true]
  end

  @tag story: "US-APMG-008"
  test "the ash-functions extension migration does not create uuid_generate_v7", ctx do
    # Given a generated extension migration for the declared PostgreSQL 18 repository.
    files =
      Path.wildcard("#{ctx.migration_path}/**/*extensions*.exs")
      |> Enum.filter(fn file ->
        String.starts_with?(File.read!(file), "defmodule #{inspect(TestRepo)}.Migrations.")
      end)

    # When this repository's actual generated extension migration is inspected.
    assert [file] = files
    contents = File.read!(file)

    # Then required native Ash functions remain and the obsolete UUID implementation is omitted.
    assert contents =~ "CREATE OR REPLACE FUNCTION ash_required"
    refute contents =~ "CREATE OR REPLACE FUNCTION uuid_generate_v7"
  end
end
