# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Version1Post do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index ["id"]
        index ["id"], unique: true, name: "test_unique_index"
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Version1Comment do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "comments"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest.Version1Post) do
        public?(true)
      end
    end
  end

  defmodule Version1Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest.Version1Post)
      resource(AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest.Version1Comment)
    end
  end

  defmodule Version2Post do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index ["id"]
        index ["id"], unique: true, name: "test_unique_index"
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      attribute(:id, :uuid,
        primary_key?: false,
        default: &Ecto.UUID.generate/0,
        public?: true
      )

      uuid_primary_key(:guid)
      attribute(:title, :string, public?: true)
    end
  end

  defmodule Version2Comment do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "comments"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest.Version2Post) do
        public?(true)
      end
    end
  end

  defmodule Version2Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest.Version2Post)
      resource(AshPostgres.MigrationGeneratorPrimaryKeyReferenceTest.Version2Comment)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    snapshot_path = Path.join(tmp_dir, "snapshots")
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Version1Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{snapshot_path: snapshot_path, migration_path: migration_path}
  end

  @tag story: "US-APMG-071"
  test "when changing the primary key, it changes properly", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given actual initial PK/FK snapshot state and a complete immutable next graph.
    # When native generation processes the changed primary key.
    # Then FK removal precedes the primary-key change and reference recreation.
    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Version2Domain,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [_file1, file2] =
             Enum.sort(Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs"))
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file = File.read!(file2)

    assert [before_index_drop, after_index_drop] =
             String.split(file, ~S[drop constraint("posts", "posts_pkey")], parts: 2)

    assert before_index_drop =~ ~S[drop constraint(:comments, "comments_post_id_fkey")]

    assert after_index_drop =~ ~S[modify :id, :uuid, null: true, primary_key: false]

    assert after_index_drop =~
             ~S[modify :post_id, references(:posts, column: :id, name: "comments_post_id_fkey", type: :uuid, prefix: "public")]
  end
end
