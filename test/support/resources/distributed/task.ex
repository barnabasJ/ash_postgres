# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.Distributed.Task do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("distributed_tasks")
    repo(AshPostgres.TestRepo)
    distribution_key(:account_id)

    references do
      reference :project, match_with: [account_id: :account_id], match_type: :full
    end
  end

  multitenancy do
    strategy(:attribute)
    attribute(:account_id)
    global?(true)
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :destroy, :update])
  end

  attributes do
    uuid_primary_key(:id, writable?: true)
    attribute(:account_id, :uuid, primary_key?: true, allow_nil?: false, public?: true)
    attribute(:title, :string, public?: true)
  end

  relationships do
    belongs_to :project, AshPostgres.Test.Distributed.Project do
      public?(true)
      allow_nil?(false)
    end

    has_many :comments, AshPostgres.Test.Distributed.Comment do
      public?(true)
    end
  end

  aggregates do
    first(:project_name, :project, :name)
    count(:comment_count, :comments)
  end
end
