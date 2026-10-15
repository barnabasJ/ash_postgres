# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.Distributed.Comment do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("distributed_comments")
    repo(AshPostgres.TestRepo)
    distribution_key(:account_id)

    references do
      reference :task, match_with: [account_id: :account_id], match_type: :full
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
    attribute(:body, :string, public?: true)
  end

  relationships do
    belongs_to :task, AshPostgres.Test.Distributed.Task do
      public?(true)
      allow_nil?(false)
    end
  end
end
