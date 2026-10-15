# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.Distributed.ProjectTag do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("distributed_project_tags")
    repo(AshPostgres.TestRepo)
    distribution_key(:account_id)

    references do
      reference :project, match_with: [account_id: :account_id], match_type: :full
      reference :tag, match_with: [account_id: :account_id], match_type: :full
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
    attribute(:account_id, :uuid, primary_key?: true, allow_nil?: false, public?: true)
  end

  relationships do
    belongs_to :project, AshPostgres.Test.Distributed.Project do
      public?(true)
      primary_key?(true)
      allow_nil?(false)
    end

    belongs_to :tag, AshPostgres.Test.Distributed.Tag do
      public?(true)
      primary_key?(true)
      allow_nil?(false)
    end
  end
end
