# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorPolymorphicTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Comment do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "comments"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      polymorphic?(true)
      repo(AshPostgres.TestRepo)
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:resource_id, :uuid, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Post do
    use Ash.Resource,
      domain: nil,
      data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      has_many(:comments, AshPostgres.MigrationGeneratorPolymorphicTest.Comment,
        public?: true,
        destination_attribute: :resource_id,
        relationship_context: %{data_layer: %{table: "post_comments"}}
      )

      belongs_to(:best_comment, AshPostgres.MigrationGeneratorPolymorphicTest.Comment,
        public?: true,
        destination_attribute: :id,
        relationship_context: %{data_layer: %{table: "post_comments"}}
      )
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorPolymorphicTest.Post)
      resource(AshPostgres.MigrationGeneratorPolymorphicTest.Comment)
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

    %{migration_path: migration_path}
  end

  @tag story: "US-APMG-070"
  test "it uses the relationship's table context if it is set", %{
    migration_path: migration_path
  } do
    # Given a real polymorphic Comment graph with a relationship-specific table context.
    # When the actual native generated migration is read.
    # Then its foreign key targets the declared post_comments table.
    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S[references(:post_comments, column: :id, name: "posts_best_comment_id_fkey", type: :uuid, prefix: "public")]
  end
end
