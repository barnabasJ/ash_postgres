# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorFkAttributeOrderTest do
  use ExUnit.Case, async: true

  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.Phase

  defmodule Post do
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
    end
  end

  defmodule CommentPostIdBeforeTitle do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "comments_post_id_before_title"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:post_id, :uuid, allow_nil?: false, public?: true)
      attribute(:title, :string, public?: true)
    end

    identities do
      identity(:uniq_title, [:title])
    end

    relationships do
      belongs_to :post, AshPostgres.MigrationGeneratorFkAttributeOrderTest.Post do
        source_attribute(:post_id)
        destination_attribute(:id)
      end
    end
  end

  defmodule CommentTitleBeforePostId do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "comments_title_before_post_id"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:post_id, :uuid, allow_nil?: false, public?: true)
    end

    identities do
      identity(:uniq_title, [:title])
    end

    relationships do
      belongs_to :post, AshPostgres.MigrationGeneratorFkAttributeOrderTest.Post do
        source_attribute(:post_id)
        destination_attribute(:id)
      end
    end
  end

  @tag story: "US-APMG-006"
  test "explicit fk attribute order does not change create table emission" do
    # Given two real resources whose explicit FK appears on opposite sides of an identity attribute.
    before_snapshots =
      MigrationGenerator.get_snapshots(CommentPostIdBeforeTitle, [Post, CommentPostIdBeforeTitle])

    after_snapshots =
      MigrationGenerator.get_snapshots(CommentTitleBeforePostId, [Post, CommentTitleBeforePostId])

    # When the native generator produces snapshots and creation operations for each.
    assert [before_snapshot] = before_snapshots
    assert [after_snapshot] = after_snapshots
    assert Enum.map(before_snapshot.attributes, & &1.source) == [:id, :post_id, :title]
    assert Enum.map(after_snapshot.attributes, & &1.source) == [:id, :title, :post_id]

    before_ops = MigrationGenerator.get_operations_from_snapshots([], before_snapshots)
    after_ops = MigrationGenerator.get_operations_from_snapshots([], after_snapshots)

    # Then both declaration orders still emit their actual table creation phase.
    assert Enum.any?(
             after_ops,
             &match?(%Phase.Create{table: "comments_title_before_post_id"}, &1)
           )

    assert Enum.any?(
             before_ops,
             &match?(%Phase.Create{table: "comments_post_id_before_title"}, &1)
           )
  end
end
