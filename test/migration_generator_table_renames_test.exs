# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorTableRenamesTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story89MessageRenameV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "messages_rename"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story89Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story89MessageRenameV1)
    end
  end

  defmodule Story89MessageRenameV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "messages_rename_new"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "messages_rename_new"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story89Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story89MessageRenameV2)
    end
  end

  defmodule Story90MessageEmptyDirRenameV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "messages_empty_dir_rename"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "messages_empty_dir_rename"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story90Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story90MessageEmptyDirRenameV1)
    end
  end

  defmodule Story90MessageEmptyDirRenameV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "messages_empty_dir_rename_new"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "messages_empty_dir_rename_new"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story90Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story90MessageEmptyDirRenameV2)
    end
  end

  defmodule Story91SchemaMessageRenameV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_messages_rename"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_messages_rename"
      schema "my_schema_rename"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story91Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story91SchemaMessageRenameV1)
    end
  end

  defmodule Story91SchemaMessageRenameV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_messages_rename_new"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_messages_rename_new"
      schema "my_schema_rename"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story91Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story91SchemaMessageRenameV2)
    end
  end

  defmodule Story92MultiRenameFooV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "multi_rename_foo"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story92Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story92MultiRenameFooV1)
    end
  end

  defmodule Story92MultiRenameFooV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "multi_rename_foo_new"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story92MultiRenameBarV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "multi_rename_bar_new"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:label, :string, public?: true)
    end
  end

  defmodule Story92Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story92MultiRenameFooV2)
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story92MultiRenameBarV1)
    end
  end

  defmodule Story93MultiRenameDeclineFooV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "multi_rename_decline_foo"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story93Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story93MultiRenameDeclineFooV1)
    end
  end

  defmodule Story93MultiRenameDeclineNewAV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "multi_rename_decline_new_a"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story93MultiRenameDeclineNewBV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "multi_rename_decline_new_b"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:label, :string, public?: true)
    end
  end

  defmodule Story93Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story93MultiRenameDeclineNewAV1)
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story93MultiRenameDeclineNewBV1)
    end
  end

  defmodule Story94SchemaMoveMessageV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_move_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story94Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story94SchemaMoveMessageV1)
    end
  end

  defmodule Story94SchemaMoveMessageV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_move_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_move_messages"
      schema "moved_messages"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story94Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story94SchemaMoveMessageV2)
    end
  end

  defmodule Story95SchemaMoveColumnMessageV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_move_column_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story95Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story95SchemaMoveColumnMessageV1)
    end
  end

  defmodule Story95SchemaMoveColumnMessageV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_move_column_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_move_column_messages"
      schema "moved_messages_with_column"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
      attribute(:subject, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story95Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story95SchemaMoveColumnMessageV2)
    end
  end

  defmodule Story96DeclinedSchemaMoveMessageV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "declined_schema_move_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story96Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story96DeclinedSchemaMoveMessageV1)
    end
  end

  defmodule Story96DeclinedSchemaMoveMessageV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "declined_schema_move_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "declined_schema_move_messages"
      schema "declined_messages"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story96Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story96DeclinedSchemaMoveMessageV2)
    end
  end

  defmodule Story97SchemaChangeMessageV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_change_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_change_messages"
      schema "old_message_schema"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story97Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story97SchemaChangeMessageV1)
    end
  end

  defmodule Story97SchemaChangeMessageV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_change_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_change_messages"
      schema "new_message_schema"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story97Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableRenamesTest.Story97SchemaChangeMessageV2)
    end
  end

  defmodule Story98DeclinedSchemaChangeMessageV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "declined_schema_change_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "declined_schema_change_messages"
      schema "old_declined_message_schema"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story98Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorTableRenamesTest.Story98DeclinedSchemaChangeMessageV1
      )
    end
  end

  defmodule Story98DeclinedSchemaChangeMessageV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "declined_schema_change_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "declined_schema_change_messages"
      schema "new_declined_message_schema"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:body, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story98Domain2 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorTableRenamesTest.Story98DeclinedSchemaChangeMessageV2
      )
    end
  end

  defmodule Story99ReferencedSchemaMoveAuthorBeforeV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_schema_move_authors"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story99ReferencingSchemaMovePostBeforeV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referencing_schema_move_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    relationships do
      belongs_to(
        :author,
        AshPostgres.MigrationGeneratorTableRenamesTest.Story99ReferencedSchemaMoveAuthorBeforeV1
      ) do
        public?(true)
        allow_nil?(false)
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story99ReferencedSchemaMoveAuthorAfterV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_schema_move_authors"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "referenced_schema_move_authors"
      schema "referenced_schema_move"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story99ReferencingSchemaMovePostAfterV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referencing_schema_move_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    relationships do
      belongs_to(
        :author,
        AshPostgres.MigrationGeneratorTableRenamesTest.Story99ReferencedSchemaMoveAuthorAfterV1
      ) do
        public?(true)
        allow_nil?(false)
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  defp position_of_substring(string, substring) do
    case :binary.match(string, substring) do
      {position, _length} -> position
      :nomatch -> nil
    end
  end

  @tag story: "US-APMG-089"
  test "generates a rename table migration when a resource table is renamed", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story89Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_messages_rename"
      )
    end)

    migration_files_before =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    assert migration_files_before != []

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story89Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "rename_messages_table"
      )
    end)

    migration_files_after =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    assert length(migration_files_after) >= length(migration_files_before) + 1

    latest_migration =
      migration_files_after
      |> List.last()
      |> File.read!()

    assert latest_migration =~
             "rename table(:messages_rename), to: table(:messages_rename_new)"

    refute latest_migration =~ "drop table(:messages_rename)"
    refute latest_migration =~ "create table(:messages_rename_new"
  end

  @tag story: "US-APMG-090"
  test "rename table migration is still proposed when new table name has an empty snapshot directory",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story90Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_messages_empty_dir_rename"
      )
    end)

    # Simulate a leftover empty directory with the new table's name in the snapshot folder.
    # Before the fix, this caused the generator to skip proposing a rename because it
    # treated the empty directory as an existing snapshot for the target table.
    empty_dir = Path.join([snapshot_path, "test_repo", "messages_empty_dir_rename_new"])
    File.mkdir_p!(empty_dir)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story90Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "rename_messages_empty_dir_table"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest_migration =
      migration_files
      |> List.last()
      |> File.read!()

    assert latest_migration =~
             "rename table(:messages_empty_dir_rename), to: table(:messages_empty_dir_rename_new)"

    refute latest_migration =~ "create table(:messages_empty_dir_rename_new"
  end

  @tag story: "US-APMG-091"
  test "rename table migration respects schema prefix", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story91Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_schema_messages_rename"
      )
    end)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story91Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "rename_schema_messages_table"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest =
      migration_files
      |> List.last()
      |> File.read!()

    assert latest =~
             ~S[rename table(:schema_messages_rename, prefix: "my_schema_rename"), to: table(:schema_messages_rename_new, prefix: "my_schema_rename")]
  end

  @tag story: "US-APMG-092"
  test "with multiple candidate new tables, prompts for which one is the rename target", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story92Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_multi_rename_foo"
      )
    end)

    # "Are you renaming multi_rename_foo?"
    # "What are you renaming it to?: ..."

    capture_io("y\nmulti_rename_foo_new\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story92Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "rename_with_unrelated_new_table"
      )
    end)

    latest =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    assert latest =~
             "rename table(:multi_rename_foo), to: table(:multi_rename_foo_new)"

    assert latest =~ "create table(:multi_rename_bar_new"
    refute latest =~ "drop table(:multi_rename_foo)"
    refute latest =~ "create table(:multi_rename_foo_new"
  end

  @tag story: "US-APMG-093"
  test "with multiple candidates, declining the rename prompt falls back to drop", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story93Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_multi_rename_decline_foo"
      )
    end)

    # "Are you renaming multi_rename_decline_foo?" -> no
    # "Generate a migration to DROP this table?" -> yes

    capture_io("n\ny\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story93Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "decline_rename_with_two_new_tables"
      )
    end)

    latest =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    assert latest =~ "drop table(:multi_rename_decline_foo)"
    assert latest =~ "create table(:multi_rename_decline_new_a"
    assert latest =~ "create table(:multi_rename_decline_new_b"
    refute latest =~ "rename table(:multi_rename_decline_foo)"
  end

  @tag story: "US-APMG-094"
  test "generates alter table set schema when a resource schema is added", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story94Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_schema_move_messages"
      )
    end)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story94Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "move_messages_schema"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest =
      migration_files
      |> List.last()
      |> File.read!()

    assert latest =~ ~S[execute("CREATE SCHEMA IF NOT EXISTS moved_messages")]

    assert latest =~
             ~S[execute("ALTER TABLE \"schema_move_messages\" SET SCHEMA \"moved_messages\"")]

    assert latest =~
             ~S[execute("ALTER TABLE \"moved_messages\".\"schema_move_messages\" SET SCHEMA \"public\"")]

    refute latest =~ "create table(:schema_move_messages"
    refute latest =~ "drop table(:schema_move_messages"
  end

  @tag story: "US-APMG-095"
  test "schema move runs before table changes that use the new schema", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story95Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_schema_move_column_messages"
      )
    end)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story95Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "move_messages_schema_and_add_column"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest =
      migration_files
      |> List.last()
      |> File.read!()

    move_pos =
      position_of_substring(
        latest,
        ~S[execute("ALTER TABLE \"schema_move_column_messages\" SET SCHEMA \"moved_messages_with_column\"")]
      )

    alter_pos =
      position_of_substring(
        latest,
        ~S[alter table(:schema_move_column_messages, prefix: "moved_messages_with_column") do]
      )

    assert is_integer(move_pos)
    assert is_integer(alter_pos)
    assert move_pos < alter_pos
    assert latest =~ "add :subject, :text"
    refute latest =~ "create table(:schema_move_column_messages"
    refute latest =~ "drop table(:schema_move_column_messages"
  end

  @tag story: "US-APMG-096"
  test "does not infer a schema move when the prompt is declined", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story96Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_declined_schema_move_messages"
      )
    end)

    capture_io("n\nn\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story96Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "decline_messages_schema_move"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest =
      migration_files
      |> List.last()
      |> File.read!()

    assert latest =~
             ~S[create table(:declined_schema_move_messages, primary_key: false, prefix: "declined_messages") do]

    refute latest =~
             ~S[execute("ALTER TABLE \"declined_schema_move_messages\" SET SCHEMA \"declined_messages\"")]

    refute latest =~ "drop table(:declined_schema_move_messages)"
  end

  @tag story: "US-APMG-097"
  test "generates alter table set schema when a resource schema changes", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story97Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_schema_change_messages"
      )
    end)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story97Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "change_messages_schema"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest =
      migration_files
      |> List.last()
      |> File.read!()

    assert latest =~ ~S[execute("CREATE SCHEMA IF NOT EXISTS new_message_schema")]

    assert latest =~
             ~S[execute("ALTER TABLE \"old_message_schema\".\"schema_change_messages\" SET SCHEMA \"new_message_schema\"")]

    assert latest =~
             ~S[execute("ALTER TABLE \"new_message_schema\".\"schema_change_messages\" SET SCHEMA \"old_message_schema\"")]

    refute latest =~ "create table(:schema_change_messages"
    refute latest =~ "drop table(:schema_change_messages"
  end

  @tag story: "US-APMG-098"
  test "does not infer an explicit schema-to-schema move when the prompt is declined", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story98Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_declined_schema_change_messages"
      )
    end)

    capture_io("n\nn\n", fn ->
      AshPostgres.MigrationGenerator.generate(Story98Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "decline_messages_schema_change"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest =
      migration_files
      |> List.last()
      |> File.read!()

    assert latest =~
             ~S[create table(:declined_schema_change_messages, primary_key: false, prefix: "new_declined_message_schema") do]

    refute latest =~
             ~S[execute("ALTER TABLE \"old_declined_message_schema\".\"declined_schema_change_messages\" SET SCHEMA \"new_declined_message_schema\"")]

    refute latest =~
             ~S[drop table(:declined_schema_change_messages, prefix: "old_declined_message_schema")]
  end

  @tag story: "US-APMG-099"
  test "moving a referenced table schema does not drop or recreate tables or foreign keys" do
    before_resources = [
      AshPostgres.MigrationGeneratorTableRenamesTest.Story99ReferencedSchemaMoveAuthorBeforeV1,
      AshPostgres.MigrationGeneratorTableRenamesTest.Story99ReferencingSchemaMovePostBeforeV1
    ]

    before_snapshots =
      Enum.flat_map(
        before_resources,
        &AshPostgres.MigrationGenerator.get_snapshots(&1, before_resources)
      )

    after_resources = [
      AshPostgres.MigrationGeneratorTableRenamesTest.Story99ReferencedSchemaMoveAuthorAfterV1,
      AshPostgres.MigrationGeneratorTableRenamesTest.Story99ReferencingSchemaMovePostAfterV1
    ]

    after_snapshots =
      Enum.flat_map(
        after_resources,
        &AshPostgres.MigrationGenerator.get_snapshots(&1, after_resources)
      )

    {up, down} =
      before_snapshots
      |> AshPostgres.MigrationGenerator.get_operations_from_snapshots(after_snapshots)
      |> AshPostgres.MigrationGenerator.build_up_and_down()

    assert up =~
             ~S[execute("ALTER TABLE \"referenced_schema_move_authors\" SET SCHEMA \"referenced_schema_move\"")]

    assert down =~
             ~S[execute("ALTER TABLE \"referenced_schema_move\".\"referenced_schema_move_authors\" SET SCHEMA \"public\"")]

    refute up =~ "create table(:referenced_schema_move_authors"
    refute up =~ "drop table(:referenced_schema_move_authors"
    refute up =~ "create table(:referencing_schema_move_posts"
    refute up =~ "drop table(:referencing_schema_move_posts"
    refute up =~ "drop constraint"
    refute up =~ "references(:referenced_schema_move_authors"
  end
end
