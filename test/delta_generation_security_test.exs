# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaGenerationSecurityTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.Operation
  alias AshPostgres.MigrationGenerator.Operation.Codec
  alias AshPostgres.MigrationGenerator.Reducer

  @moduletag :tmp_dir

  defmodule Tier do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "delta_security_tiers"
      repo AshPostgres.TemporalTestRepo
    end

    temporal do
      strategy(:context)
      attribute(:valid_at)
    end

    attributes do
      attribute(:id, :integer, primary_key?: true, allow_nil?: false)

      attribute(:valid_at, Ash.Type.Range,
        allow_nil?: false,
        constraints: [
          inner_type: :datetime,
          inner_constraints: [precision: :microsecond],
          lower: [inclusive?: true],
          upper: [inclusive?: false]
        ]
      )
    end
  end

  defmodule Subscription do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "delta_security_subscriptions"
      repo AshPostgres.TemporalTestRepo
    end

    temporal do
      strategy(:context)
      attribute(:valid_at)
    end

    attributes do
      attribute(:id, :integer, primary_key?: true, allow_nil?: false)

      attribute(:valid_at, Ash.Type.Range,
        allow_nil?: false,
        constraints: [
          inner_type: :datetime,
          inner_constraints: [precision: :microsecond],
          lower: [inclusive?: true],
          upper: [inclusive?: false]
        ]
      )
    end

    relationships do
      belongs_to :tier, Tier do
        attribute_type(:integer)
        temporal_keys({:valid_at, :valid_at})
      end
    end
  end

  defmodule TemporalDomain do
    use Ash.Domain

    resources do
      resource(Tier)
      resource(Subscription)
    end
  end

  defmodule BeforeMove do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "delta_security_schema_moves"
      repo AshPostgres.TestRepo
    end

    attributes do
      attribute(:id, :integer, primary_key?: true, allow_nil?: false)
    end
  end

  defmodule AfterMove do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "delta_security_schema_moves"
      schema "archive"
      repo AshPostgres.TestRepo
    end

    attributes do
      attribute(:id, :integer, primary_key?: true, allow_nil?: false)
    end
  end

  defmodule BeforeDomain do
    use Ash.Domain

    resources do
      resource(BeforeMove)
    end
  end

  defmodule AfterDomain do
    use Ash.Domain

    resources do
      resource(AfterMove)
    end
  end

  @tag story: "US-APDELTA-62"
  test "persisted temporal relationship deltas retain the desired reference without codegen drift",
       %{tmp_dir: tmp_dir} do
    # Given two temporal resources connected through a period-aware foreign key.
    options = generation_options(tmp_dir)
    [desired] = MigrationGenerator.get_snapshots(Subscription, [Tier, Subscription])
    desired = desired |> Codec.encode_full_state() |> Codec.decode_full_state()

    # When the public generator writes native operations and the reader reduces their persisted JSON.
    generate(TemporalDomain, options)
    state = Reducer.load_reduced_state(desired, struct!(MigrationGenerator, options))
    reference = Enum.find(state.attributes, &(&1.source == :tier_id)).references
    expected = Enum.find(desired.attributes, &(&1.source == :tier_id)).references

    # Then the complete reference and desired attribute state survive, and unchanged generation writes nothing.
    assert reference == expected
    assert reference.temporal_period == ["valid_at", "valid_at"]

    assert Enum.sort_by(state.attributes, & &1.source) ==
             Enum.sort_by(desired.attributes, & &1.source)

    assert state.temporal == desired.temporal

    assert Enum.any?(
             persisted_operations(options),
             &match?(%Operation.AddTemporalForeignKey{}, &1)
           )

    original_files = generated_files(tmp_dir)
    generate(TemporalDomain, options)
    assert generated_files(tmp_dir) == original_files
  end

  @tag story: "US-APDELTA-63"
  test "a schema move carries its complete persisted delta history into unchanged generation", %{
    tmp_dir: tmp_dir
  } do
    # Given a resource whose initial migration and attribute history are persisted in delta format.
    options = generation_options(tmp_dir)
    generate(BeforeDomain, options)

    original_deltas =
      Path.wildcard(Path.join(options[:snapshot_path], "**/delta_security_schema_moves/*.json"))

    assert length(original_deltas) == 1

    # When its schema changes through public generation, with the native confirmation answered through IO.
    generate(AfterDomain, options, "y\n")
    [desired] = MigrationGenerator.get_snapshots(AfterMove, [AfterMove])
    desired = desired |> Codec.encode_full_state() |> Codec.decode_full_state()
    state = Reducer.load_reduced_state(desired, struct!(MigrationGenerator, options))

    moved_deltas =
      Path.wildcard(
        Path.join(options[:snapshot_path], "**/archive.delta_security_schema_moves/*.json")
      )

    # Then the reader sees initial state plus the move, and unchanged generation writes nothing.
    assert state.schema == "archive"
    assert state.table == desired.table
    assert state.attributes == desired.attributes
    assert length(moved_deltas) == 2

    assert Enum.all?(original_deltas, fn path ->
             File.exists?(Path.join(Path.dirname(hd(moved_deltas)), Path.basename(path)))
           end)

    assert Enum.any?(persisted_operations(options), &match?(%Operation.MoveTableSchema{}, &1))
    original_files = generated_files(tmp_dir)
    generate(AfterDomain, options)
    assert generated_files(tmp_dir) == original_files
  end

  @tag story: "US-APDELTA-64"
  test "the persisted reader rejects temporal foreign keys without logical attribute metadata", %{tmp_dir: tmp_dir} do
    # Given persisted temporal FK data that lacks the logical attribute needed for reconstruction.
    [desired] = MigrationGenerator.get_snapshots(Subscription, [Tier, Subscription])
    options = generation_options(tmp_dir)
    folder = MigrationGenerator.get_snapshot_path(desired, MigrationGenerator.get_snapshot_folder(desired, struct!(MigrationGenerator, options)))
    File.mkdir_p!(folder)
    operation = %Operation.AddTemporalForeignKey{
      table: desired.table,
      column: :tier_id,
      source_period: "valid_at",
      destination_table: "delta_security_tiers",
      destination_attribute: :id,
      destination_period: "valid_at"
    }
    File.write!(Path.join(folder, "20261105000000.json"), Codec.encode_delta([operation]))

    # When the normal persisted-state reader reduces that delta.
    # Then it identifies the missing state instead of silently discarding the reference.
    assert_raise Reducer.ConflictError, ~r/requires the original logical attribute metadata/, fn ->
      Reducer.load_reduced_state(desired, struct!(MigrationGenerator, options))
    end
  end

  defp generation_options(tmp_dir) do
    [
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations"),
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations"),
      quiet: true,
      format: false,
      auto_name: true,
      snapshot_format: :delta
    ]
  end

  defp generate(domain, options, input \\ "") do
    capture_io(input, fn -> MigrationGenerator.generate(domain, options) end)
  end

  defp generated_files(tmp_dir) do
    tmp_dir
    |> Path.join("**/*")
    |> Path.wildcard()
    |> Enum.filter(&File.regular?/1)
    |> Enum.sort()
  end

  defp persisted_operations(options) do
    options[:snapshot_path]
    |> Path.join("**/*.json")
    |> Path.wildcard()
    |> Enum.flat_map(fn path ->
      json = File.read!(path)
      if Codec.delta?(json), do: Codec.decode_delta(json).operations, else: []
    end)
  end
end
