# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorFollowUpTest do
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

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule InitialDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.InitialPost)
    end
  end

  defmodule IdentityAttributeRenamePost do
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
      identity(:title, [:foobar])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule IdentityAttributeRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.IdentityAttributeRenamePost)
    end
  end

  defmodule IndexRenamePost do
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
      identity_index_names(title: "titles_r_unique_dawg")
    end

    identities do
      identity(:title, [:title])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule IndexRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.IndexRenamePost)
    end
  end

  defmodule IdentityPredicatePost do
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
      identity_wheres_to_sql(title: "title != 'fred' and title != 'george'")
    end

    identities do
      identity(:title, [:title], where: expr(title not in ["fred", "george"]))
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule IdentityPredicateDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.IdentityPredicatePost)
    end
  end

  defmodule AddedFieldPost do
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

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:name, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule AddedFieldDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.AddedFieldPost)
    end
  end

  defmodule ConfirmedRenamePost do
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
      attribute(:name, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule ConfirmedRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.ConfirmedRenamePost)
    end
  end

  defmodule DeclinedRenamePost do
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
      attribute(:name, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule DeclinedRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.DeclinedRenamePost)
    end
  end

  defmodule SelectedRenamePost do
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
      attribute(:name, :string, allow_nil?: false, public?: true)
      attribute(:subject, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule SelectedRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SelectedRenamePost)
    end
  end

  defmodule IdentitySelectedRenamePost do
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
      identity(:subject, [:subject])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:subject, :string, public?: true)
    end
  end

  defmodule IdentitySelectedRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.IdentitySelectedRenamePost)
    end
  end

  defmodule DeclinedSelectedRenamePost do
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
      attribute(:name, :string, allow_nil?: false, public?: true)
      attribute(:subject, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule DeclinedSelectedRenameDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.DeclinedSelectedRenamePost)
    end
  end

  defmodule SharedAttributesPost do
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
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule SharedAttributesPost2 do
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
      attribute(:name, :string, public?: true)
    end
  end

  defmodule SharedAttributesDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SharedAttributesPost)
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SharedAttributesPost2)
    end
  end

  defmodule SharedIdentitiesPost do
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

    identities do
      identity(:unique_title, [:title])
    end
  end

  defmodule SharedIdentitiesPost2 do
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
      attribute(:name, :string, public?: true)
    end

    identities do
      identity(:unique_name, [:name])
    end
  end

  defmodule SharedIdentitiesDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SharedIdentitiesPost)
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SharedIdentitiesPost2)
    end
  end

  defmodule ConcurrentIdentitiesPost do
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
      attribute(:name, :string, public?: true)
    end

    identities do
      identity(:unique_title, [:title])
      identity(:unique_name, [:name])
    end
  end

  defmodule ConcurrentIdentitiesDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.ConcurrentIdentitiesPost)
    end
  end

  defmodule SharedOptionalAttributePost do
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
      attribute(:example, :string, allow_nil?: false, public?: true)
    end
  end

  defmodule SharedOptionalAttributePost2 do
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
    end
  end

  defmodule SharedOptionalAttributeDomain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SharedOptionalAttributePost)
      resource(AshPostgres.MigrationGeneratorFollowUpTest.SharedOptionalAttributePost2)
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

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-021"
  test "when renaming an attribute of an index, it is properly renamed without modifying the attribute",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(IdentityAttributeRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file2)
    refute contents =~ "modify"
  end

  @tag story: "US-APMG-022"
  test "when renaming an index, it is properly renamed", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(IndexRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~
             ~S[ALTER INDEX posts_title_index RENAME TO titles_r_unique_dawg]
  end

  @tag story: "US-APMG-023"
  test "when changing the where clause, it is properly dropped and recreated", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(IdentityPredicateDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert [file_before, _] =
             String.split(
               File.read!(file2),
               ~S{create unique_index(:posts, [:title], name: "posts_title_index", where: "(title != 'fred' and title != 'george')")}
             )

    assert file_before =~
             ~S{drop_if_exists unique_index(:posts, [:title], name: "posts_title_index")}
  end

  @tag story: "US-APMG-024"
  test "when adding a field, it adds the field", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(AddedFieldDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~
             ~S[add :name, :text, null: false]
  end

  @tag story: "US-APMG-025"
  test "when renaming a field, it asks if you are renaming it, and renames it if you are", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(ConfirmedRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~ ~S[rename table(:posts), :title, to: :name]
  end

  @tag story: "US-APMG-026"
  test "when renaming a field, it asks if you are renaming it, and adds it if you aren't", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("n\n", fn ->
      AshPostgres.MigrationGenerator.generate(DeclinedRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~
             ~S[add :name, :text, null: false]
  end

  @tag story: "US-APMG-027"
  test "when renaming a field, it asks which field you are renaming it to, and renames it if you are",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("y\nsubject\n", fn ->
      AshPostgres.MigrationGenerator.generate(SelectedRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    # Up migration
    assert File.read!(file2) =~ ~S[rename table(:posts), :title, to: :subject]

    # Down migration
    assert File.read!(file2) =~ ~S[rename table(:posts), :subject, to: :title]
  end

  @tag story: "US-APMG-028"
  test "when renaming a field with an identity, it asks which field you are renaming it to, and updates indexes in the correct order",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("y\nsubject\n", fn ->
      AshPostgres.MigrationGenerator.generate(IdentitySelectedRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    contents = File.read!(file2)
    [up_side, down_side] = String.split(contents, "def down", parts: 2)

    up_side_parts =
      String.split(up_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    drop_index =
      Enum.find_index(up_side_parts, fn x ->
        x == "drop_if_exists unique_index(:posts, [:title], name: \"posts_title_index\")"
      end)

    rename_table =
      Enum.find_index(up_side_parts, fn x ->
        x == "rename table(:posts), :title, to: :subject"
      end)

    create_index =
      Enum.find_index(up_side_parts, fn x ->
        x == "create unique_index(:posts, [:subject], name: \"posts_subject_index\")"
      end)

    assert drop_index < rename_table
    assert rename_table < create_index

    down_side_parts =
      String.split(down_side, "\n", trim: true)
      |> Enum.map(&String.trim/1)

    drop_index =
      Enum.find_index(down_side_parts, fn x ->
        x ==
          "drop_if_exists unique_index(:posts, [:subject], name: \"posts_subject_index\")"
      end)

    rename_table =
      Enum.find_index(down_side_parts, fn x ->
        x == "rename table(:posts), :subject, to: :title"
      end)

    create_index =
      Enum.find_index(down_side_parts, fn x ->
        x == "create unique_index(:posts, [:title], name: \"posts_title_index\")"
      end)

    assert drop_index < rename_table
    assert rename_table < create_index
  end

  @tag story: "US-APMG-029"
  test "when renaming a field, it asks which field you are renaming it to, and adds it if you arent",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("n\n", fn ->
      AshPostgres.MigrationGenerator.generate(DeclinedSelectedRenameDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~
             ~S[add :subject, :text, null: false]
  end

  @tag story: "US-APMG-030"
  test "when multiple schemas apply to the same table, all attributes are added", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(SharedAttributesDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~
             ~S[add :foobar, :text]

    assert File.read!(file2) =~
             ~S[add :name, :text]
  end

  @tag story: "US-APMG-031"
  test "when multiple schemas apply to the same table, all identities are added", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(SharedIdentitiesDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file1_content = File.read!(file1)

    assert file1_content =~
             "create unique_index(:posts, [:title], name: \"posts_title_index\")"

    file2_content = File.read!(file2)

    assert file2_content =~
             "drop_if_exists unique_index(:posts, [:title], name: \"posts_title_index\")"

    assert file2_content =~
             "create unique_index(:posts, [:name], name: \"posts_unique_name_index\")"

    assert file2_content =~
             "create unique_index(:posts, [:title], name: \"posts_unique_title_index\")"
  end

  @tag story: "US-APMG-032"
  test "when concurrent-indexes flag set to true, identities are added in separate migration",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(ConcurrentIdentitiesDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        concurrent_indexes: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, _file2, file3] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file3_content = File.read!(file3)

    assert file3_content =~ ~S[@disable_ddl_transaction true]

    assert file3_content =~
             "create unique_index(:posts, [:title], name: \"posts_unique_title_index\", concurrently: true)"

    assert file3_content =~
             "create unique_index(:posts, [:name], name: \"posts_unique_name_index\", concurrently: true)"
  end

  @tag story: "US-APMG-033"
  test "when an attribute exists only on some of the resources that use the same table, it isn't marked as null: false",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    # Given an actual persisted initial snapshot and an immutable next-version resource.
    # When native generation receives the authored rename answers and writes the follow-up.
    # Then the original SQL and operation-order assertions remain true.
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(SharedOptionalAttributeDomain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file2) =~
             ~S[add :example, :text] <> "\n"

    refute File.read!(file2) =~ ~S[null: false]
  end
end
