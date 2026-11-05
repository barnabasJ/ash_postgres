# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorIdentityTypeTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Post do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "identity_posts"
      repo(AshPostgres.TestRepo)
      migration_types(id: :identity, sequence_id: :identity)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      integer_primary_key(:id)

      attribute(:sequence_id, :integer,
        generated?: true,
        allow_nil?: false,
        public?: true
      )

      attribute(:title, :string, public?: true)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorIdentityTypeTest.Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-037"
  test "uses :identity when set in migration_types", %{migration_path: migration_path} do
    # Given a real resource and its case-owned native migration.
    # When the actual generated file is read.
    # Then its declared integer generation strategy is preserved.
    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_contents = File.read!(file)
    assert file_contents =~ ~S[add :id, :identity, null: false, primary_key: true]
    assert file_contents =~ ~S[add :sequence_id, :identity, null: false]
  end
end
