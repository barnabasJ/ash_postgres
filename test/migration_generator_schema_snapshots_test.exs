# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorSchemaSnapshotsTest do
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

    postgres do
      migration_types(second_title: {:varchar, 16})

      identity_wheres_to_sql(second_title: "(second_title like '%foo%')")

      schema("example")
    end

    identities do
      identity(:title, [:title])

      identity :second_title, [:second_title] do
        nils_distinct?(false)
        where expr(contains(second_title, "foo"))
      end
    end

    attributes do
      uuid_primary_key(:id)
      uuid_v7_primary_key(:other_id)
      attribute(:title, :string, public?: true)
      attribute(:second_title, :string, public?: true)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorSchemaSnapshotsTest.Post)
    end
  end

  @spec uuid_v7_default() :: String.t()
  defp uuid_v7_default do
    if AshPostgres.TestRepo.use_builtin_uuidv7_function?(),
      do: ~S[fragment("uuidv7()")],
      else: ~S[fragment("uuid_generate_v7()")]
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

  @tag story: "US-APMG-010"
  test "the migration sets up resources correctly", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given the real resource and its case-owned generated files.
    # When the native migration and snapshot are read.
    # Then all SQL, type and index assertions retain their original contract.
    # the snapshot exists and contains valid json
    assert File.read!(Path.wildcard("#{snapshot_path}/test_repo/example.posts/*.json"))
           |> Jason.decode!(keys: :atoms!)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_contents = File.read!(file)

    # the migration creates the schema
    assert file_contents =~ "execute(\"CREATE SCHEMA IF NOT EXISTS example\")"

    # the migration creates the table
    assert file_contents =~ "create table(:posts, primary_key: false, prefix: \"example\") do"

    # the migration sets up the custom_indexes
    assert file_contents =~
             ~S{create index(:posts, ["id"], name: "test_unique_index", unique: true, prefix: "example")}

    assert file_contents =~ ~S{create index(:posts, ["id"]}

    assert file_contents =~
             ~S{create unique_index(:posts, [:second_title], name: "posts_second_title_index", prefix: "example", nulls_distinct: false, where: "((second_title like '%foo%'))")}

    # the migration adds the id, with its default
    assert file_contents =~
             ~S[add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true]

    # the migration adds the other_id, with its default
    assert file_contents =~
             "add :other_id, :uuid, null: false, default: #{uuid_v7_default()}, primary_key: true"

    # the migration adds other attributes
    assert file_contents =~ ~S[add :title, :text]

    # the migration adds custom attributes
    assert file_contents =~ ~S[add :second_title, :varchar, size: 16]

    # the migration creates unique_indexes based on the identities of the resource
    assert file_contents =~
             ~S{create unique_index(:posts, [:title], name: "posts_title_index", prefix: "example")}
  end
end
