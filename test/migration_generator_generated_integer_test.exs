# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorGeneratedIntegerTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Post do
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
        public?: true
      )

      attribute(:views, :integer, public?: true)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorGeneratedIntegerTest.Post)
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

  @tag story: "US-APMG-036"
  test "when an integer is generated and default nil, it is a bigserial", %{
    migration_path: migration_path
  } do
    # Given a real resource and its case-owned native migration.
    # When the actual generated file is read.
    # Then its declared integer generation strategy is preserved.
    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S[add :id, :bigserial, null: false, primary_key: true]

    assert File.read!(file) =~
             ~S[add :views, :bigint]
  end
end
