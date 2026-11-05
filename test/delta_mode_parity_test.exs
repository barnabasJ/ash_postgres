# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeParityTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story025DeltaParity1V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_1")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
    end

    identities do
      identity(:unique_title, [:title])
    end
  end

  defmodule Story025Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story025DeltaParity1V1)
    end
  end

  defmodule Story026BeforeParityV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_2")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Story026AfterParityV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_2")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true, allow_nil?: false)
      attribute(:body, :string, public?: true)
    end

    identities do
      identity(:unique_title, [:title])
    end
  end

  defmodule Story026Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story026BeforeParityV1)
    end
  end

  defmodule Story026Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story026AfterParityV1)
    end
  end

  defmodule Story027DeltaParityRemoveV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_remove")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story027Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story027DeltaParityRemoveV1)
    end
  end

  defmodule Story027DeltaParityRemoveV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_remove")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      # :body removed
    end
  end

  defmodule Story027Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story027DeltaParityRemoveV2)
    end
  end

  defmodule Story028DeltaParityCustomIdxV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_custom_idx")
      repo(AshPostgres.TestRepo)

      custom_indexes do
        index(["title"], name: "delta_parity_custom_idx_title")
        index(["body"], unique: true, name: "delta_parity_custom_idx_body_uniq")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story028Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story028DeltaParityCustomIdxV1)
    end
  end

  defmodule Story029DeltaParityCheckV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_check")
      repo(AshPostgres.TestRepo)

      check_constraints do
        check_constraint(:amount, "positive_amount", check: "amount > 0")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:amount, :integer, public?: true)
    end
  end

  defmodule Story029Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story029DeltaParityCheckV1)
    end
  end

  defmodule Story030DeltaParityAuthorV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_authors")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story030DeltaParityPostFKV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_posts_fk")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:author, AshPostgres.DeltaModeParityTest.Story030DeltaParityAuthorV1,
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Story030Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story030DeltaParityAuthorV1)
      resource(AshPostgres.DeltaModeParityTest.Story030DeltaParityPostFKV1)
    end
  end

  defmodule Story031DeltaParityOrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_orgs")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story031DeltaParityMemberV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_members")
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
      belongs_to(:organization, AshPostgres.DeltaModeParityTest.Story031DeltaParityOrgV1,
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Story031Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story031DeltaParityOrgV1)
      resource(AshPostgres.DeltaModeParityTest.Story031DeltaParityMemberV1)
    end
  end

  defmodule Story032DeltaParitySchemaV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_schema")
      schema("example")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Story032Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story032DeltaParitySchemaV1)
    end
  end

  defmodule Story033DeltaParityRenameV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_rename")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Story033Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story033DeltaParityRenameV1)
    end
  end

  defmodule Story033DeltaParityRenameV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_parity_rename")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Story033Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeParityTest.Story033DeltaParityRenameV2)
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

  describe "migration-content parity (delta vs full)" do
    @tag story: "US-APDI-025"
    test "creating a resource produces identical migrations in full and delta modes", %{
      full_sp: full_sp,
      full_mp: full_mp,
      delta_sp: delta_sp,
      delta_mp: delta_mp,
      tmp_dir: tmp_dir
    } do
      generate(Story025Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "full_tenant"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story025Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "delta_tenant"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp),
             "Migration content diverged between full and delta modes"
    end

    @tag story: "US-APDI-026"
    test "evolving a resource (add + alter + index) produces identical migrations", %{
      full_sp: full_sp,
      full_mp: full_mp,
      delta_sp: delta_sp,
      delta_mp: delta_mp,
      tmp_dir: tmp_dir
    } do
      run = fn domain, sp, mp, tenant, format ->
        generate(domain,
          snapshot_path: sp,
          migration_path: mp,
          tenant_migration_path: tenant,
          quiet: true,
          format: false,
          auto_name: true,
          snapshot_format: format
        )
      end

      full_tenant = Path.join(tmp_dir, "full_tenant")
      delta_tenant = Path.join(tmp_dir, "delta_tenant")

      run.(Story026Domain1, full_sp, full_mp, full_tenant, :full)
      run.(Story026Domain1, delta_sp, delta_mp, delta_tenant, :delta)

      run.(Story026Domain2, full_sp, full_mp, full_tenant, :full)
      run.(Story026Domain2, delta_sp, delta_mp, delta_tenant, :delta)

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp),
             "Migration content diverged between full and delta modes after resource evolution"
    end

    @tag story: "US-APDI-027"
    test "removing an attribute produces identical DROP COLUMN migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story027Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft1"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story027Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt1"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      generate(Story027Domain2,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft1"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story027Domain2,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt1"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end

    @tag story: "US-APDI-028"
    test "custom index produces identical CREATE INDEX migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story028Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft2"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story028Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt2"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end

    @tag story: "US-APDI-029"
    test "check constraint produces identical migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story029Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft3"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story029Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt3"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end

    @tag story: "US-APDI-030"
    test "belongs_to references produce identical FK migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story030Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft4"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story030Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt4"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end

    @tag story: "US-APDI-031"
    test "attribute multitenancy produces identical migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story031Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft5"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story031Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt5"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end

    @tag story: "US-APDI-032"
    test "schema-prefixed table produces identical migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story032Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft6"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story032Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt6"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end

    @tag story: "US-APDI-033"
    test "renaming an attribute produces identical RENAME migration in both modes",
         %{
           full_sp: full_sp,
           full_mp: full_mp,
           delta_sp: delta_sp,
           delta_mp: delta_mp,
           tmp_dir: tmp_dir
         } do
      generate(Story033Domain1,
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft7"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story033Domain1,
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt7"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      # The generator asks "Are you renaming :title to :name?" — answer YES.

      generate(Story033Domain2,
        input: "y\n",
        snapshot_path: full_sp,
        migration_path: full_mp,
        tenant_migration_path: Path.join(tmp_dir, "ft7"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :full
      )

      generate(Story033Domain2,
        input: "y\n",
        snapshot_path: delta_sp,
        migration_path: delta_mp,
        tenant_migration_path: Path.join(tmp_dir, "dt7"),
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      assert resource_migration_content(full_mp) == resource_migration_content(delta_mp)
    end
  end
end
