# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeBranchesSQLTest do
  use AshPostgres.RepoCase, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.Operation
  alias AshPostgres.MigrationGenerator.Reducer
  @moduletag :migration
  @moduletag :tmp_dir
  @mt %{strategy: nil, attribute: nil, global: nil}

  defmodule Story019DeltaRealMergeV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_real_merge")
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

  defmodule Story019Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesSQLTest.Story019DeltaRealMergeV1)
    end
  end

  defmodule Story019DeltaRealMergeV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_real_merge")
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

  defmodule Story019Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesSQLTest.Story019DeltaRealMergeV2)
    end
  end

  defmodule Story019DeltaRealMergeV3 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_real_merge")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:tags, :string, public?: true)
    end
  end

  defmodule Story019Domain3 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesSQLTest.Story019DeltaRealMergeV3)
    end
  end

  defmodule Story019DeltaRealMergeV4 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_real_merge")
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

  defmodule Story019Domain4 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesSQLTest.Story019DeltaRealMergeV4)
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

  describe "parallel branches — merge-friendly deltas" do
    @tag story: "US-APDI-019"
    test "real sequential codegen on diverged branches produces deltas that merge cleanly",
         %{snapshot_path: sp, migration_path: mp, tmp_dir: tmp_dir} do
      # The fabricated-JSON test above proves the reducer can fold two
      # parallel deltas. This test goes further: it actually invokes
      # `MigrationGenerator.generate/2` independently on two diverged
      # snapshot directories (simulating two branches running codegen),
      # then physically merges the directories and runs codegen again,
      # checking that no extra migration is emitted. No JSON is hand-rolled.

      sp_a = Path.join(tmp_dir, "branch_a_snapshots")
      sp_b = Path.join(tmp_dir, "branch_b_snapshots")
      mp_a = Path.join(tmp_dir, "branch_a_migrations")
      mp_b = Path.join(tmp_dir, "branch_b_migrations")

      # ---- main: define resource, generate initial state ----

      run_codegen(Story019Domain1, sp, mp)

      # Sanity: only the initial delta file exists.
      assert length(delta_files(sp, "delta_real_merge")) == 1

      # ---- branch A: fork BOTH the snapshot dir and the migration dir from
      # the post-main state. A real `git checkout -b` on a working repo
      # carries both directories along. ----
      File.cp_r!(sp, sp_a)
      File.cp_r!(mp, mp_a)

      run_codegen(Story019Domain2, sp_a, mp_a)

      # ---- branch B: fork from the SAME pre-divergence point, add :tags ----
      File.cp_r!(sp, sp_b)
      File.cp_r!(mp, mp_b)

      run_codegen(Story019Domain3, sp_b, mp_b)

      # Each branch has its own (initial + new) deltas.
      branch_a_files = delta_files(sp_a, "delta_real_merge")
      branch_b_files = delta_files(sp_b, "delta_real_merge")
      assert length(branch_a_files) == 2
      assert length(branch_b_files) == 2

      # The new delta in branch B carries an `:tags` AddAttribute.
      branch_b_new = List.last(branch_b_files)
      decoded_b = read_delta(branch_b_new)

      assert Enum.any?(
               decoded_b.operations,
               &match?(
                 %Operation.AddAttribute{attribute: %{source: :tags}},
                 &1
               )
             )

      # ---- simulate `git merge`: copy branch B's *new* delta into branch A's
      # snapshot directory and migration directory. The shared initial files
      # are already in branch A, so this lands branch B's NEW delta + new
      # migration alongside.
      branch_b_resource_dir =
        Path.dirname(List.first(Path.wildcard("#{sp_b}/**/delta_real_merge/*.json")))

      branch_a_resource_dir =
        Path.dirname(List.first(Path.wildcard("#{sp_a}/**/delta_real_merge/*.json")))

      branch_b_initial_basename = branch_b_files |> List.first() |> Path.basename()

      branch_b_resource_dir
      |> File.ls!()
      |> Enum.reject(&(&1 == branch_b_initial_basename))
      |> Enum.each(fn f ->
        File.cp!(
          Path.join(branch_b_resource_dir, f),
          Path.join(branch_a_resource_dir, f)
        )
      end)

      # Same merge for migration files: copy branch B's NEW migration files
      # into branch A's migration tree.
      branch_a_initial_migrations =
        migration_files(mp_a) |> Enum.map(&Path.basename/1) |> MapSet.new()

      branch_b_migration_files = migration_files(mp_b)

      Enum.each(branch_b_migration_files, fn b_file ->
        if !MapSet.member?(branch_a_initial_migrations, Path.basename(b_file)) do
          rel = Path.relative_to(b_file, mp_b)
          dest = Path.join(mp_a, rel)
          File.mkdir_p!(Path.dirname(dest))
          File.cp!(b_file, dest)
        end
      end)

      # Branch A folder now has 3 files: shared initial + branch_a's new + branch_b's new
      assert length(delta_files(sp_a, "delta_real_merge")) == 3

      # The reducer state combines all three.
      merged_state =
        Reducer.load_reduced_state(
          %{
            table: "delta_real_merge",
            schema: nil,
            repo: AshPostgres.TestRepo,
            multitenancy: @mt
          },
          %MigrationGenerator{snapshot_path: sp_a, dev: false, quiet: true}
        )

      sources = merged_state.attributes |> Enum.map(& &1.source) |> Enum.sort()
      assert :id in sources
      assert :title in sources
      assert :body in sources
      assert :tags in sources

      # ---- post-merge codegen: resource reflects both new attributes,
      # so the next codegen must NOT emit a new delta or migration.

      files_before = delta_files(sp_a, "delta_real_merge")
      migrations_before = migration_files(mp_a)

      run_codegen(Story019Domain4, sp_a, mp_a)

      assert delta_files(sp_a, "delta_real_merge") == files_before,
             "Codegen on the merged branch produced a spurious delta — the reducer's state did not match the resource definition."

      assert migration_files(mp_a) == migrations_before,
             "Codegen on the merged branch produced a spurious migration."

      # ---- run the merged migrations end-to-end against a real DB and assert
      # the resulting schema has all four columns. This proves not only that
      # the deltas merged cleanly but that the migration files produced from
      # diverged branches are mutually compatible when applied in order.
      refute table_exists?("delta_real_merge")
      migrations_mp_a = compile_migrations(mp_a)
      run_migrations(migrations_mp_a, :up)

      assert table_exists?("delta_real_merge")
      assert column_exists?("delta_real_merge", "id")
      assert column_exists?("delta_real_merge", "title")
      assert column_exists?("delta_real_merge", "body")
      assert column_exists?("delta_real_merge", "tags")

      run_migrations(migrations_mp_a, :down)
      refute table_exists?("delta_real_merge")
    end
  end
end
