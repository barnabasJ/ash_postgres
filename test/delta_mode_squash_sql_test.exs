# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeSquashSQLTest do
  use AshPostgres.RepoCase, async: true
  import AshPostgres.Test.DeltaModeHelpers

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story021DeltaSquashIncrV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_incr")
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

  defmodule Story021Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashSQLTest.Story021DeltaSquashIncrV1)
    end
  end

  defmodule Story021DeltaSquashIncrV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_incr")
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

  defmodule Story021Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashSQLTest.Story021DeltaSquashIncrV2)
    end
  end

  defmodule Story021DeltaSquashIncrV3 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
      attribute(:tags, :string, public?: true)
    end
  end

  defmodule Story021Domain3 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashSQLTest.Story021DeltaSquashIncrV3)
    end
  end

  defmodule Story021DeltaSquashIncrV4 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_incr")
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

  defmodule Story021Domain4 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashSQLTest.Story021DeltaSquashIncrV4)
    end
  end

  defmodule Story021DeltaSquashIncrV5 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_incr")
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

  defmodule Story021Domain5 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashSQLTest.Story021DeltaSquashIncrV5)
    end
  end

  defmodule Story021DeltaSquashIncrV6 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_squash_incr")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:body, :string, public?: true)
      attribute(:tags, :string, public?: true)
    end
  end

  defmodule Story021Domain6 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeSquashSQLTest.Story021DeltaSquashIncrV6)
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

  describe "squash in delta mode" do
    @tag story: "US-APDI-021"
    test "post-squash incremental codegen emits the same migration as the no-squash baseline",
         %{tmp_dir: tmp_dir} do
      # Two parallel timelines: path A never squashes, path B squashes after
      # the second codegen. Both end with the same resource definition and a
      # final codegen that adds :tags. The third migration's content must be
      # identical between A and B — squash must not perturb the diff engine.
      sp_a = Path.join(tmp_dir, "noop_squash_a_sp")
      mp_a = Path.join(tmp_dir, "noop_squash_a_mp")
      sp_b = Path.join(tmp_dir, "noop_squash_b_sp")
      mp_b = Path.join(tmp_dir, "noop_squash_b_mp")

      # ---- Path A: never squash. ----

      run_codegen(Story021Domain1, sp_a, mp_a)

      run_codegen(Story021Domain2, sp_a, mp_a)

      run_codegen(Story021Domain3, sp_a, mp_a)

      # ---- Path B: squash mid-way. Re-establish state from scratch in a
      # second snapshot/migration tree. ----

      run_codegen(Story021Domain4, sp_b, mp_b)

      run_codegen(Story021Domain5, sp_b, mp_b)

      Mix.Tasks.AshPostgres.SquashSnapshots.run(["--snapshot-path", sp_b, "--quiet"])

      run_codegen(Story021Domain6, sp_b, mp_b)

      # The final migration in each path is the "add tags" change. It must be
      # the same between paths — squash must NOT rewrite the diff.
      [_, _, last_a] = migration_files(mp_a)
      [_, _, last_b] = migration_files(mp_b)

      a_body = migration_body_only(last_a)
      b_body = migration_body_only(last_b)

      assert a_body == b_body,
             "Post-squash incremental migration diverged from the no-squash baseline.\n\nA:\n#{a_body}\n\nB:\n#{b_body}"

      # Run both chains in this Sandbox transaction and assert the resulting
      # schemas are identical.
      migrations_mp_a = compile_migrations(mp_a)
      run_migrations(migrations_mp_a, :up)
      schema_a = capture_table_schema("delta_squash_incr")
      run_migrations(migrations_mp_a, :down)

      migrations_mp_b = compile_migrations(mp_b)
      run_migrations(migrations_mp_b, :up)
      schema_b = capture_table_schema("delta_squash_incr")
      run_migrations(migrations_mp_b, :down)

      assert schema_a == schema_b,
             "Post-squash chain yielded a different DB schema than the un-squashed chain"
    end
  end
end
