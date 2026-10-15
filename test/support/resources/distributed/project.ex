# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.Distributed.Project do
  @moduledoc """
  A resource whose table is distributed (sharded) by `account_id`, as with Citus.

  The distributed resources mirror the layout such databases require: the distribution
  key is part of every primary key, and every foreign key between distributed tables
  includes it (`match_with`).
  """
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("distributed_projects")
    repo(AshPostgres.TestRepo)
    distribution_key(:account_id)
  end

  multitenancy do
    strategy(:attribute)
    attribute(:account_id)
    global?(true)
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :destroy, :update])

    update :add_tags do
      require_atomic?(false)
      argument(:tags, {:array, :map})
      change(manage_relationship(:tags, type: :append, on_lookup: :relate, on_no_match: :error))
    end
  end

  attributes do
    uuid_primary_key(:id, writable?: true)
    attribute(:account_id, :uuid, primary_key?: true, allow_nil?: false, public?: true)
    attribute(:name, :string, public?: true)
  end

  relationships do
    has_many :tasks, AshPostgres.Test.Distributed.Task do
      public?(true)
    end

    has_one :latest_task, AshPostgres.Test.Distributed.Task do
      public?(true)
      from_many?(true)
      sort(title: :desc)
    end

    has_many :first_two_tasks, AshPostgres.Test.Distributed.Task do
      public?(true)
      sort(title: :asc)
      limit(2)
    end

    many_to_many :tags, AshPostgres.Test.Distributed.Tag do
      public?(true)
      through(AshPostgres.Test.Distributed.ProjectTag)
      source_attribute_on_join_resource(:project_id)
      destination_attribute_on_join_resource(:tag_id)
    end
  end

  aggregates do
    count(:task_count, :tasks)
    count(:comment_count, [:tasks, :comments])
    exists(:has_tasks, :tasks)
    first(:first_task_title, :tasks, :title, sort: [title: :asc])
    list(:task_titles, :tasks, :title, sort: [title: :asc])
    count(:tag_count, :tags)
    list(:tag_names, :tags, :name, sort: [name: :asc])
  end
end
