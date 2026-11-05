# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeMultitenancyTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation
  alias AshPostgres.MigrationGenerator.Operation.Codec
  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story015DeltaTenantThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_tenant_thing")
      repo(AshPostgres.TestRepo)
    end

    multitenancy do
      strategy(:context)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Story015Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMultitenancyTest.Story015DeltaTenantThingV1)
    end
  end

  defmodule Story016DeltaOrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_orgs")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story016DeltaMemberV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_members")
      repo(AshPostgres.TestRepo)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:organization_id)
      global?(false)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(:organization, AshPostgres.DeltaModeMultitenancyTest.Story016DeltaOrgV1,
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Story016Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeMultitenancyTest.Story016DeltaOrgV1)
      resource(AshPostgres.DeltaModeMultitenancyTest.Story016DeltaMemberV1)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations"),
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations"),
      full_sp: Path.join(tmp_dir, "full/snapshots"),
      full_mp: Path.join(tmp_dir, "full/migrations"),
      delta_sp: Path.join(tmp_dir, "delta/snapshots"),
      delta_mp: Path.join(tmp_dir, "delta/migrations")
    }
  end

  describe "multitenancy" do
    @tag story: "US-APDI-015"
    test "resources with context multitenancy store deltas under tenants/", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story015Domain1, sp, mp)

      tenant_deltas = Path.wildcard("#{sp}/**/tenants/delta_tenant_thing/*.json")
      assert length(tenant_deltas) == 1

      delta = tenant_deltas |> List.first() |> read_delta()
      assert Codec.delta?(File.read!(List.first(tenant_deltas)))

      create_table = Enum.find(delta.operations, &match?(%Operation.CreateTable{}, &1))
      assert create_table.multitenancy.strategy == :context
    end

    @tag story: "US-APDI-016"
    test "attribute multitenancy persists the tenancy attribute in ops", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story016Domain1, sp, mp)

      [file] = delta_files(sp, "delta_members")
      delta = read_delta(file)

      create_table = Enum.find(delta.operations, &match?(%Operation.CreateTable{}, &1))
      assert create_table.multitenancy.strategy == :attribute
      assert create_table.multitenancy.attribute == :organization_id
    end
  end
end
