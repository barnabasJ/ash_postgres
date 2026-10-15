# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.Distributed.Tag do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("distributed_tags")
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
  end

  attributes do
    uuid_primary_key(:id, writable?: true)
    attribute(:account_id, :uuid, primary_key?: true, allow_nil?: false, public?: true)
    attribute(:name, :string, public?: true)
  end

  relationships do
    many_to_many :projects, AshPostgres.Test.Distributed.Project do
      public?(true)
      through(AshPostgres.Test.Distributed.ProjectTag)
      source_attribute_on_join_resource(:tag_id)
      destination_attribute_on_join_resource(:project_id)
    end
  end

  aggregates do
    count(:project_count, :projects)
  end
end
