# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorTenantIdentityTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Scenario1ChannelVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "channels"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      table "channels"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    multitenancy do
      strategy(:attribute)
      attribute(:project_id)
    end

    identities do
      identity(:unique_type_per_project, [:project_id, :type])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:project_id, :uuid, allow_nil?: false, public?: true)
      attribute(:type, :string, allow_nil?: false, public?: true)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Scenario1Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario1ChannelVersion1)
    end
  end

  defmodule Scenario2ShopVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "shops"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Scenario2EventVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "events"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Scenario2Stage1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2ShopVersion1)
      resource(AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2EventVersion1)
    end
  end

  defmodule Scenario2TicketVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tickets"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    multitenancy do
      strategy(:attribute)
      attribute(:shop_id)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:code, :string, allow_nil?: false, public?: true)
    end

    relationships do
      belongs_to(:event, AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2EventVersion1,
        allow_nil?: false,
        public?: true
      )

      belongs_to(:shop, AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2ShopVersion1,
        allow_nil?: false,
        public?: true
      )
    end

    identities do
      identity(:unique_code, [:code])
    end
  end

  defmodule Scenario2Stage2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2ShopVersion1)
      resource(AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2EventVersion1)
      resource(AshPostgres.MigrationGeneratorTenantIdentityTest.Scenario2TicketVersion1)
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

  @tag story: "US-APMG-072"
  test "identity including tenant attribute does not duplicate columns in index", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable tenant-scoped resource graphs and case-owned output.
    # When native generation writes their declared identities.
    # Then the original tenant-column and operation-order assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario1Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_content = File.read!(file)

    # The index should only have project_id and type, not project_id twice
    assert file_content =~
             ~S{create unique_index(:channels, [:project_id, :type], name: "channels_unique_type_per_project_index")}

    # Make sure it doesn't have duplicate columns
    refute file_content =~
             ~S{create unique_index(:channels, [:project_id, :project_id, :type]}
  end

  @tag story: "US-APMG-073"
  test "a new table's identity index is created after its tenant attribute is added (issue #904)",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    # Given real immutable tenant-scoped resource graphs and case-owned output.
    # When native generation writes their declared identities.
    # Then the original tenant-column and operation-order assertions remain intact.

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Stage2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    file_contents =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    [up, _down] = String.split(file_contents, "def down", parts: 2)

    unique_index_pos =
      position_of_substring(
        up,
        ~S{create unique_index(:tickets, [:shop_id, :code], name: "tickets_unique_code_index")}
      )

    shop_id_pos = position_of_substring(up, "add :shop_id")

    assert unique_index_pos && shop_id_pos,
           "expected migration to contain both the unique index and the shop_id column"

    assert shop_id_pos < unique_index_pos,
           "expected the shop_id column to be added before the unique index that covers it"
  end
end
