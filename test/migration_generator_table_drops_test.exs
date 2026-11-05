# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorTableDropsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1PostForDropVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts_for_drop"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario1MessageForDropVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "messages_for_drop"
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

  defmodule Scenario1Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario1PostForDropVersion1)
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario1MessageForDropVersion1)
    end
  end

  defmodule Scenario1Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario1PostForDropVersion1)
    end
  end

  defmodule Scenario2SoloPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "solo_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario2Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario2SoloPostVersion1)
    end
  end

  defmodule Scenario2OtherResourceVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "other_table"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario2Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario2OtherResourceVersion1)
    end
  end

  defmodule Scenario3OptOutPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "opt_out_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario3OptOutMessageVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "opt_out_messages"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario3Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario3OptOutPostVersion1)
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario3OptOutMessageVersion1)
    end
  end

  defmodule Scenario3Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario3OptOutPostVersion1)
    end
  end

  defmodule Scenario4ManagedPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "managed_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Scenario4ExternallyManagedStatusVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "externally_managed_statuses"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Scenario4Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario4ManagedPostVersion1)

      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario4ExternallyManagedStatusVersion1
      )
    end
  end

  defmodule Scenario4ExternallyManagedStatusVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "externally_managed_statuses"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "externally_managed_statuses"
      repo(AshPostgres.TestRepo)
      migrate?(false)
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Scenario4Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario4ManagedPostVersion1)

      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario4ExternallyManagedStatusVersion2
      )
    end
  end

  defmodule Scenario5SchemaPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "schema_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "schema_posts"
      schema "my_schema"
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario5Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario5SchemaPostVersion1)
    end
  end

  defmodule Scenario5DummyForSchemaVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "dummy_table"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario5Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario5DummyForSchemaVersion1)
    end
  end

  defmodule Scenario6CompanyForDropOrderVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "companies_for_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Scenario6ProjectForDropOrderVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "projects_for_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(
        :company,
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario6CompanyForDropOrderVersion1
      ) do
        allow_nil?(false)
        public?(true)
      end
    end

    postgres do
      references do
        reference(:company, on_delete: :delete)
      end
    end
  end

  defmodule Scenario6TaskForDropOrderVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tasks_for_drop_order"
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
        :project,
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario6ProjectForDropOrderVersion1
      ) do
        allow_nil?(false)
        public?(true)
      end
    end

    postgres do
      references do
        reference(:project, on_delete: :delete)
      end
    end
  end

  defmodule Scenario6KeepaliveForDropOrderVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "keepalive_for_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Scenario6Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario6CompanyForDropOrderVersion1)
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario6ProjectForDropOrderVersion1)
      resource(AshPostgres.MigrationGeneratorTableDropsTest.Scenario6TaskForDropOrderVersion1)

      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario6KeepaliveForDropOrderVersion1
      )
    end
  end

  defmodule Scenario6Domain2 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario6KeepaliveForDropOrderVersion1
      )
    end
  end

  defmodule Scenario7ReferencedDropOrderParentVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_drop_parent_for_fk_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      integer_primary_key(:id)
      attribute(:label, :string, public?: true)
    end
  end

  defmodule Scenario7ReferencedDropOrderChildOneBeforeVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_drop_child_one_for_fk_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      integer_primary_key(:id)
      attribute(:parent_id, :integer, public?: true)
    end

    relationships do
      belongs_to(
        :parent,
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderParentVersion1
      ) do
        source_attribute(:parent_id)
        public?(true)
        allow_nil?(true)
      end
    end

    postgres do
      references do
        reference(:parent)
      end
    end
  end

  defmodule Scenario7ReferencedDropOrderChildTwoBeforeVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_drop_child_two_for_fk_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      integer_primary_key(:id)
      attribute(:parent_id, :integer, public?: true)
    end

    relationships do
      belongs_to(
        :parent,
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderParentVersion1
      ) do
        source_attribute(:parent_id)
        public?(true)
        allow_nil?(true)
      end
    end

    postgres do
      references do
        reference(:parent)
      end
    end
  end

  defmodule Scenario7Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderParentVersion1
      )

      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderChildOneBeforeVersion1
      )

      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderChildTwoBeforeVersion1
      )
    end
  end

  defmodule Scenario7ReferencedDropOrderChildOneAfterVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_drop_child_one_for_fk_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      integer_primary_key(:id)
      attribute(:parent_id, :integer, public?: true)
    end
  end

  defmodule Scenario7ReferencedDropOrderChildTwoAfterVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "referenced_drop_child_two_for_fk_drop_order"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      integer_primary_key(:id)
      attribute(:parent_id, :integer, public?: true)
    end
  end

  defmodule Scenario7Domain2 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderChildOneAfterVersion1
      )

      resource(
        AshPostgres.MigrationGeneratorTableDropsTest.Scenario7ReferencedDropOrderChildTwoAfterVersion1
      )
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @spec position_of_substring(string :: String.t(), substring :: String.t()) ::
          non_neg_integer() | nil
  defp position_of_substring(string, substring) do
    case :binary.match(string, substring) do
      {position, _length} -> position
      :nomatch -> nil
    end
  end

  @tag story: "US-APMG-074"
  test "generates drop table migration when a resource is removed from the domain", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_posts_and_messages"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    assert migration_files != []

    first_migration = File.read!(List.first(migration_files))
    assert first_migration =~ "create table(:posts_for_drop"
    assert first_migration =~ "create table(:messages_for_drop"

    assert File.exists?(Path.join(snapshot_path, "test_repo/posts_for_drop"))
    assert File.exists?(Path.join(snapshot_path, "test_repo/messages_for_drop"))

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "remove_messages"
      )
    end)

    migration_files_after =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    assert length(migration_files_after) >= 2

    latest_migration =
      migration_files_after
      |> List.last()
      |> File.read!()

    assert latest_migration =~ "drop table(:messages_for_drop)",
           "Expected migration to contain 'drop table(:messages_for_drop)', got:\n#{latest_migration}"

    refute File.exists?(Path.join(snapshot_path, "test_repo/messages_for_drop")),
           "Orphan snapshot dir should be removed after generating drop migration"

    assert File.exists?(Path.join(snapshot_path, "test_repo/posts_for_drop"))
  end

  @tag story: "US-APMG-075"
  test "second generate after drop reports no changes", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_solo"
      )
    end)

    count_before =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    capture_io("n\ny\n", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "drop_solo_add_other"
      )
    end)

    count_after_first_drop =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    last_output =
      capture_io("", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario2Domain2,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: true,
          format: false,
          auto_name: true,
          name: "no_op"
        )
      end)

    count_after_second =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    assert count_after_first_drop > count_before
    assert last_output =~ "No changes detected"

    assert count_after_second == count_after_first_drop,
           "Expected no new migration files (count #{count_after_first_drop}), got #{count_after_second}"
  end

  @tag story: "US-APMG-076"
  test "when user opts out of drop, snapshot is updated and we do not ask again", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario3Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_opt_out_tables"
      )
    end)

    assert File.exists?(Path.join(snapshot_path, "test_repo/opt_out_messages"))

    count_before =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    capture_io("n\n", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario3Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "would_remove_opt_out_messages"
      )
    end)

    count_after_opt_out =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    assert count_after_opt_out == count_before,
           "Expected no new migration when opting out of drop, got #{count_after_opt_out - count_before} new file(s)"

    assert File.exists?(Path.join(snapshot_path, "test_repo/opt_out_messages")),
           "Opted-out table snapshot dir should remain"

    last_output =
      capture_io("", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario3Domain2,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: true,
          format: false,
          auto_name: true,
          name: "no_op_after_opt_out"
        )
      end)

    count_after_second =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    assert count_after_second == count_after_opt_out,
           "Expected no new migration on second run after opt-out (count #{count_after_opt_out}), got #{count_after_second}"

    assert File.exists?(Path.join(snapshot_path, "test_repo/opt_out_messages"))
    refute last_output =~ "Generate a migration to DROP this table?"
  end

  @tag story: "US-APMG-077"
  test "does not prompt to drop tables for existing resources with migrate? false", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_managed_resources"
      )
    end)

    migration_count =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    assert File.exists?(Path.join(snapshot_path, "test_repo/externally_managed_statuses"))
    assert File.exists?(Path.join(snapshot_path, "test_repo/managed_posts"))

    last_output =
      capture_io("y\n", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario4Domain2,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: true,
          format: false,
          auto_name: true,
          name: "ignore_unmanaged_resource"
        )
      end)

    migration_count_after =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> length()

    latest_migration =
      migration_path
      |> Path.join("**/*.exs")
      |> Path.wildcard()
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    assert migration_count_after == migration_count, latest_migration
    assert File.exists?(Path.join(snapshot_path, "test_repo/externally_managed_statuses"))
    refute last_output =~ "Generate a migration to DROP this table?"
  end

  @tag story: "US-APMG-078"
  test "drop table migration uses correct prefix when resource has schema", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario5Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_schema_post"
      )
    end)

    capture_io("y\n", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario5Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "remove_schema_post"
      )
    end)

    migration_files =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    latest = File.read!(List.last(migration_files))

    assert latest =~ "drop table(:schema_posts"
    assert latest =~ ~S(prefix: "my_schema")
  end

  @tag story: "US-APMG-079"
  test "drop table migration orders dependent tables before referenced tables", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario6Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "add_drop_order_resources"
      )
    end)

    capture_io("y\ny\ny\n", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario6Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "remove_drop_order_resources"
      )
    end)

    latest_migration =
      migration_path
      |> Path.join("**/*remove_drop_order_resources*.exs")
      |> Path.wildcard()
      |> List.first()
      |> File.read!()

    task_pos = position_of_substring(latest_migration, "drop table(:tasks_for_drop_order)")

    project_pos =
      position_of_substring(latest_migration, "drop table(:projects_for_drop_order)")

    company_pos =
      position_of_substring(latest_migration, "drop table(:companies_for_drop_order)")

    assert is_integer(task_pos)
    assert is_integer(project_pos)
    assert is_integer(company_pos)
    assert task_pos < project_pos
    assert project_pos < company_pos
  end

  @tag story: "US-APMG-080"
  test "drops dependent foreign keys before dropping referenced table", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real persisted table snapshots and complete immutable resource graphs.
    # When native generation receives the developer’s drop choices.
    # Then the original SQL order, file counts and snapshot-retention assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario7Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        snapshots_only: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario7Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        dev: true,
        name: "repro_drop_referenced_table"
      )
    end)

    migration_file =
      Path.wildcard("#{migration_path}/*repro_drop_referenced_table*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> List.first()

    assert migration_file,
           "Expected a generated migration containing repro_drop_referenced_table, got: #{inspect(Path.wildcard(migration_path <> "/*.exs"))}"

    file = File.read!(migration_file)

    [_, up_and_rest] = String.split(file, "def up do")
    [up_code, _] = String.split(up_and_rest, "def down do")

    parent_drop_idx =
      position_of_substring(
        up_code,
        "drop table(:referenced_drop_parent_for_fk_drop_order)"
      )

    child_one_drop_idx =
      position_of_substring(
        up_code,
        ~s[drop constraint(:referenced_drop_child_one_for_fk_drop_order, "referenced_drop_child_one_for_fk_drop_order_parent_id_fkey")]
      )

    child_two_drop_idx =
      position_of_substring(
        up_code,
        ~s[drop constraint(:referenced_drop_child_two_for_fk_drop_order, "referenced_drop_child_two_for_fk_drop_order_parent_id_fkey")]
      )

    assert is_integer(parent_drop_idx),
           "Expected up migration to drop the referenced table before finalizing, got:\n#{up_code}"

    assert is_integer(child_one_drop_idx),
           "Expected up migration to drop child one foreign key before parent table removal, got:\n#{up_code}"

    assert is_integer(child_two_drop_idx),
           "Expected up migration to drop child two foreign key before parent table removal, got:\n#{up_code}"

    assert child_one_drop_idx < parent_drop_idx,
           "Expected child one FK drop (pos #{child_one_drop_idx}) before parent drop (pos #{parent_drop_idx}) in migration:\n#{up_code}"

    assert child_two_drop_idx < parent_drop_idx,
           "Expected child two FK drop (pos #{child_two_drop_idx}) before parent drop (pos #{parent_drop_idx}) in migration:\n#{up_code}"
  end
end
