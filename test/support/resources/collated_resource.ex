defmodule AshPostgres.Test.CollatedPost do
  @moduledoc false
  use Ash.Resource,
    domain: AshPostgres.Test.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "collated_posts"
    repo AshPostgres.TestRepo
  end

  actions do
    default_accept(:*)
    defaults([:read, :destroy, create: :*, update: :*])
  end

  attributes do
    uuid_primary_key(:id)

    # Collated string attributes with different collations
    attribute :title, AshPostgres.CollatedString do
      constraints(collation: "C")
      allow_nil?(false)
    end

    attribute :content, AshPostgres.CollatedString do
      constraints(collation: "en_US.utf8")
      allow_nil?(true)
    end

    attribute :tags, AshPostgres.CollatedString do
      constraints(collation: "POSIX")
      allow_nil?(true)
    end

    # Standard string field for comparison
    attribute :author, :string do
      allow_nil?(true)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end
end
