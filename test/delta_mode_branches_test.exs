# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeBranchesTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation
  alias AshPostgres.MigrationGenerator.Operation.Codec
  alias AshPostgres.MigrationGenerator.Reducer
  @moduletag :migration
  @moduletag :tmp_dir
  @mt %{strategy: nil, attribute: nil, global: nil}

  defmodule Story017DeltaBranch1V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_branch_1")
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

  defmodule Story017Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesTest.Story017DeltaBranch1V1)
    end
  end

  defmodule Story017DeltaBranch1V2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_branch_1")
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

  defmodule Story017Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesTest.Story017DeltaBranch1V2)
    end
  end

  defmodule Story018DeltaBranch2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_branch_2")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story018Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeBranchesTest.Story018DeltaBranch2V1)
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
    @tag story: "US-APDI-017"
    test "two deltas from separate 'branches' merge cleanly and reduce to combined state",
         %{snapshot_path: sp, migration_path: mp} do
      # Initial state (main branch): a resource with id + title

      run_codegen(Story017Domain1, sp, mp)

      [initial_file] = delta_files(sp, "delta_branch_1")
      initial_delta = read_delta(initial_file)

      # Simulate Dev A's branch delta: adds :body
      delta_dir = Path.dirname(initial_file)

      dev_a_ops = [
        %Operation.AddAttribute{
          table: "delta_branch_1",
          schema: nil,
          multitenancy: @mt,
          old_multitenancy: @mt,
          attribute: %{
            source: :body,
            type: :text,
            default: "nil",
            size: nil,
            precision: nil,
            scale: nil,
            primary_key?: false,
            allow_nil?: true,
            generated?: false,
            references: nil
          }
        }
      ]

      # Simulate Dev B's branch delta: adds :tags
      dev_b_ops = [
        %Operation.AddAttribute{
          table: "delta_branch_1",
          schema: nil,
          multitenancy: @mt,
          old_multitenancy: @mt,
          attribute: %{
            source: :tags,
            type: :text,
            default: "nil",
            size: nil,
            precision: nil,
            scale: nil,
            primary_key?: false,
            allow_nil?: true,
            generated?: false,
            references: nil
          }
        }
      ]

      File.write!(
        Path.join(delta_dir, "20990101000000.json"),
        Codec.encode_delta(dev_a_ops, %{previous_hash: initial_delta.resulting_hash})
      )

      File.write!(
        Path.join(delta_dir, "20990101000001.json"),
        Codec.encode_delta(dev_b_ops, %{previous_hash: initial_delta.resulting_hash})
      )

      # Reducing should include id, title, body, tags — no conflict
      state = reduce_dir(sp, "delta_branch_1")
      sources = Enum.map(state.attributes, & &1.source) |> Enum.sort()
      assert :id in sources
      assert :title in sources
      assert :body in sources
      assert :tags in sources

      # Codegen on the post-merge main (resource reflects both additions)

      before_files = delta_files(sp, "delta_branch_1")
      before_migrations = migration_files(mp)

      run_codegen(Story017Domain2, sp, mp)

      # No new deltas, no new migrations — reducer already reflects the state
      # implied by both branch deltas.
      assert delta_files(sp, "delta_branch_1") == before_files
      assert migration_files(mp) == before_migrations
    end

    @tag story: "US-APDI-018"
    test "conflicting deltas (same attribute added in two 'branches') raise ConflictError",
         %{snapshot_path: sp, migration_path: mp} do
      run_codegen(Story018Domain1, sp, mp)

      [initial_file] = delta_files(sp, "delta_branch_2")
      delta_dir = Path.dirname(initial_file)

      dup_op = fn type ->
        %Operation.AddAttribute{
          table: "delta_branch_2",
          schema: nil,
          multitenancy: @mt,
          old_multitenancy: @mt,
          attribute: %{
            source: :clashing_name,
            type: type,
            default: "nil",
            size: nil,
            precision: nil,
            scale: nil,
            primary_key?: false,
            allow_nil?: true,
            generated?: false,
            references: nil
          }
        }
      end

      File.write!(
        Path.join(delta_dir, "20990101000000.json"),
        Codec.encode_delta([dup_op.(:text)])
      )

      File.write!(
        Path.join(delta_dir, "20990101000001.json"),
        Codec.encode_delta([dup_op.(:integer)])
      )

      assert_raise Reducer.ConflictError,
                   ~r/AddAttribute: attribute :clashing_name already exists/,
                   fn ->
                     reduce_dir(sp, "delta_branch_2")
                   end
    end
  end
end
