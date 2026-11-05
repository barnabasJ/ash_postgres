# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeRunnableSQLTest do
  use AshPostgres.RepoCase, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.Operation.Codec
  alias AshPostgres.MigrationGenerator.Reducer
  @moduletag :migration
  @moduletag :tmp_dir
  @mt %{strategy: nil, attribute: nil, global: nil}

  defmodule Story036DeltaPolyCommentV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      polymorphic?(true)
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:resource_id, :uuid, public?: true)
      attribute(:body, :string, public?: true)
    end
  end

  defmodule Story036DeltaPolyPostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_poly_posts")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      has_many(:comments, AshPostgres.DeltaModeRunnableSQLTest.Story036DeltaPolyCommentV1,
        public?: true,
        destination_attribute: :resource_id,
        relationship_context: %{data_layer: %{table: "delta_poly_post_comments"}}
      )
    end
  end

  defmodule Story036Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableSQLTest.Story036DeltaPolyPostV1)
      resource(AshPostgres.DeltaModeRunnableSQLTest.Story036DeltaPolyCommentV1)
    end
  end

  defmodule Story037DeltaTenantRunnableV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_tenant_runnable")
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
      attribute(:label, :string, public?: true)
    end
  end

  defmodule Story037Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeRunnableSQLTest.Story037DeltaTenantRunnableV1)
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

  describe "generated migrations are runnable" do
    @tag story: "US-APDI-036"
    test "polymorphic resources land in concrete-table snapshot dirs and produce runnable migrations",
         %{snapshot_path: sp, migration_path: mp} do
      run_codegen(Story036Domain1, sp, mp)

      # Polymorphic placement: the comment resource lands in the concrete
      # table folder named after the relationship_context, NOT in a
      # comment-named folder.
      poly_files = Path.wildcard("#{sp}/**/delta_poly_post_comments/*.json")
      assert length(poly_files) == 1
      assert Codec.delta?(File.read!(List.first(poly_files)))

      # The post table also gets its own delta folder.
      post_files = Path.wildcard("#{sp}/**/delta_poly_posts/*.json")
      assert length(post_files) == 1

      # Reducer reads the polymorphic concrete-table folder cleanly.
      poly_state =
        Reducer.load_reduced_state(
          %{
            table: "delta_poly_post_comments",
            schema: nil,
            repo: AshPostgres.TestRepo,
            multitenancy: @mt
          },
          %MigrationGenerator{snapshot_path: sp, dev: false, quiet: true}
        )

      sources = Enum.map(poly_state.attributes, & &1.source)
      assert :id in sources
      assert :resource_id in sources
      assert :body in sources

      # End-to-end: run the migrations and verify both tables materialize.
      refute table_exists?("delta_poly_posts")
      refute table_exists?("delta_poly_post_comments")

      migrations_mp = compile_migrations(mp)
      run_migrations(migrations_mp, :up)

      assert table_exists?("delta_poly_posts")
      assert table_exists?("delta_poly_post_comments")
      assert column_exists?("delta_poly_post_comments", "body")

      run_migrations(migrations_mp, :down)
      refute table_exists?("delta_poly_posts")
      refute table_exists?("delta_poly_post_comments")
    end

    @tag story: "US-APDI-037"
    test "context multitenancy in delta mode produces a tenant migration that runs via migrate_tenant",
         %{snapshot_path: sp, migration_path: mp, tmp_dir: tmp_dir} do
      tenant_mp = Path.join(tmp_dir, "tenant_migrations_runnable")

      generate(Story037Domain1,
        snapshot_path: sp,
        migration_path: mp,
        tenant_migration_path: tenant_mp,
        quiet: true,
        format: false,
        auto_name: true,
        snapshot_format: :delta
      )

      tenant_migration_files =
        "#{tenant_mp}/**/*_migrate_resources*.exs"
        |> Path.wildcard()
        |> Enum.reject(&String.contains?(&1, "extensions"))
        |> Enum.sort()

      assert tenant_migration_files != [], "no tenant migration was generated"

      # Create a real schema and run the tenant migration end-to-end.
      tenant_name = "delta_test_tenant_#{:rand.uniform(1_000_000)}"

      # The tenant schema and its migrations use this case's Sandbox transaction.
      AshPostgres.TestRepo.query!(~s|CREATE SCHEMA "#{tenant_name}"|, [])

      try do
        AshPostgres.MultiTenancy.migrate_tenant(
          tenant_name,
          AshPostgres.TestRepo,
          tenant_mp
        )

        # Assert the table was created INSIDE the tenant's schema.
        %{rows: [[exists]]} =
          AshPostgres.TestRepo.query!(
            "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = $1 AND table_name = 'delta_tenant_runnable')",
            [tenant_name]
          )

        assert exists,
               "tenant migration ran but `#{tenant_name}.delta_tenant_runnable` does not exist"

        # And the column.
        %{rows: [[col_exists]]} =
          AshPostgres.TestRepo.query!(
            "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = $1 AND table_name = 'delta_tenant_runnable' AND column_name = 'label')",
            [tenant_name]
          )

        assert col_exists
      after
        AshPostgres.TestRepo.query!(~s|DROP SCHEMA IF EXISTS "#{tenant_name}" CASCADE|, [])
      end
    end
  end
end
