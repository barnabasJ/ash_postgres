# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorReferencesTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story101PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule Story101Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story101PostV1,
        public?: true
      )
    end
  end

  defmodule Story101Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story101PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story101Post2V1)
    end
  end

  defmodule Story102TemplateV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "templates"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story102PhaseV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "phases"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story102TemplatePhaseV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "template_phase"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, allow_nil?: false, public?: true)
    end

    identities do
      identity(:id, [:id])
    end

    relationships do
      belongs_to(:template, AshPostgres.MigrationGeneratorReferencesTest.Story102TemplateV1,
        primary_key?: true,
        allow_nil?: false,
        public?: true
      )

      belongs_to(:phase, AshPostgres.MigrationGeneratorReferencesTest.Story102PhaseV1,
        primary_key?: true,
        allow_nil?: false,
        public?: true
      )

      belongs_to(:template_phase, __MODULE__) do
        source_attribute(:follows)
        destination_attribute(:id)
        attribute_writable?(true)
        allow_nil?(true)
        public?(true)
      end
    end
  end

  defmodule Story102Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story102TemplateV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story102PhaseV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story102TemplatePhaseV1)
    end
  end

  defmodule Story103PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      attribute(:id, :string, primary_key?: true, allow_nil?: false, public?: true)
      attribute(:title, :string, public?: true)
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule Story103Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      attribute(:id, :string, primary_key?: true, allow_nil?: false, public?: true)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story103PostV1,
        attribute_type: :string,
        public?: true
      )
    end
  end

  defmodule Story103Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story103PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story103Post2V1)
    end
  end

  defmodule Story104PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule Story104Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story104PostV1) do
        public?(true)
      end
    end

    postgres do
      references do
        reference(:post, match_with: [related_key_id: :key_id], match_type: :partial)
      end
    end
  end

  defmodule Story104Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story104PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story104Post2V1)
    end
  end

  defmodule Story105PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule Story105Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story105PostV1) do
        public?(true)
      end
    end

    postgres do
      references do
        reference(:post, index?: true)
      end
    end
  end

  defmodule Story105Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story105PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story105Post2V1)
    end
  end

  defmodule Story106PartialIndexPostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "partial_index_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story106PartialIndexCommentV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "partial_index_comments"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story106PartialIndexPostV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:post, index?: true, index_where: :not_nil)
      end
    end
  end

  defmodule Story106Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story106PartialIndexPostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story106PartialIndexCommentV1)
    end
  end

  defmodule Story107FullIndexPostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "index_where_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story107FullIndexCommentV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "index_where_comments"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story107FullIndexPostV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:post, index?: true)
      end
    end
  end

  defmodule Story107Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story107FullIndexPostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story107FullIndexCommentV1)
    end
  end

  defmodule Story107IndexWherePartialPostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "index_where_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story107IndexWherePartialCommentV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "index_where_comments"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(
        :post,
        AshPostgres.MigrationGeneratorReferencesTest.Story107IndexWherePartialPostV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:post, index?: true, index_where: "post_id IS NOT NULL")
      end
    end
  end

  defmodule Story107Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story107IndexWherePartialPostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story107IndexWherePartialCommentV1)
    end
  end

  defmodule Story108PostRefIdxV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story108Post2RefIdxV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story108PostRefIdxV1,
        public?: true
      )
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      references do
        reference(:post, index?: true)
      end
    end
  end

  defmodule Story108Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story108PostRefIdxV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story108Post2RefIdxV1)
    end
  end

  defmodule Story108PostRefNoIdxV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Story108Post2RefNoIdxV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story108PostRefNoIdxV1,
        public?: true
      )
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      references do
        reference(:post, index?: false)
      end
    end
  end

  defmodule Story108Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story108PostRefNoIdxV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story108Post2RefNoIdxV1)
    end
  end

  defmodule Story109PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end

    postgres do
      schema "example"
    end
  end

  defmodule Story109Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story109PostV1) do
        public?(true)
      end
    end

    postgres do
      schema "example"

      references do
        reference(:post, index?: true, deferrable: :initially)
      end
    end
  end

  defmodule Story109Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story109PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story109Post2V1)
    end
  end

  defmodule Story109Post2V2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story109PostV1) do
        public?(true)
      end
    end

    postgres do
      schema "example"

      references do
        reference(:post, index?: true, deferrable: true)
      end
    end
  end

  defmodule Story109Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story109PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story109Post2V2)
    end
  end

  defmodule Story110OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story110PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story110OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story110Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story110PostV1) do
        public?(true)
      end

      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story110OrgV1) do
        public?(true)
      end
    end

    postgres do
      references do
        reference(:post, index?: true)
      end
    end
  end

  defmodule Story110Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story110OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story110PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story110Post2V1)
    end
  end

  defmodule Story111OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story111PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:key_id, :uuid, allow_nil?: false, public?: true)
      attribute(:foobar, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story111OrgV1) do
        public?(true)
      end
    end

    postgres do
      references do
        reference(:org, index?: true)
      end
    end
  end

  defmodule Story111Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story111OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story111PostV1)
    end
  end

  defmodule Story112OrgForMtTransitionV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs_for_mt_transition"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story112UserForMtTransitionV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users_for_mt_transition"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Story112TokenForMtTransitionV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tokens_for_mt_transition"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(
        :user,
        AshPostgres.MigrationGeneratorReferencesTest.Story112UserForMtTransitionV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:user, index?: true)
      end
    end
  end

  defmodule Story112Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story112OrgForMtTransitionV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story112UserForMtTransitionV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story112TokenForMtTransitionV1)
    end
  end

  defmodule Story112TokenForMtTransitionV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tokens_for_mt_transition"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story112OrgForMtTransitionV1,
        public?: true
      )

      belongs_to(
        :user,
        AshPostgres.MigrationGeneratorReferencesTest.Story112UserForMtTransitionV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:user, index?: true)
      end
    end
  end

  defmodule Story112Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story112OrgForMtTransitionV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story112UserForMtTransitionV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story112TokenForMtTransitionV2)
    end
  end

  defmodule Story113OrgForMtDropV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs_for_mt_drop"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story113UserForMtDropV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users_for_mt_drop"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end
  end

  defmodule Story113TokenForMtDropV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tokens_for_mt_drop"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story113OrgForMtDropV1,
        public?: true
      )

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story113UserForMtDropV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:user, index?: true)
      end
    end
  end

  defmodule Story113Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story113OrgForMtDropV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story113UserForMtDropV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story113TokenForMtDropV1)
    end
  end

  defmodule Story113TokenForMtDropV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tokens_for_mt_drop"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story113UserForMtDropV1,
        public?: true
      )
    end

    postgres do
      references do
        reference(:user, index?: true)
      end
    end
  end

  defmodule Story113Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story113OrgForMtDropV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story113UserForMtDropV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story113TokenForMtDropV2)
    end
  end

  defmodule Story114OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true, public?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story114UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:secondary_id, :uuid, public?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:key_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story114OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story114UserThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      attribute(:id, :string, primary_key?: true, allow_nil?: false, public?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:related_key_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story114OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story114UserV1,
        destination_attribute: :secondary_id,
        public?: true
      )
    end

    postgres do
      references do
        reference(:user, match_with: [related_key_id: :key_id], match_type: :full)
      end
    end
  end

  defmodule Story114Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story114OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story114UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story114UserThingV1)
    end
  end

  defmodule Story115OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story115UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:secondary_id, :uuid, public?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:key_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    identities do
      identity(:unique_name, [:name], all_tenants?: true)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story115OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story115Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story115OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story115UserV1)
    end
  end

  defmodule Story116OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story116UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:archived, :boolean, public?: true, default: false)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    identities do
      identity(:unique_name, [:name], all_tenants?: true)
    end

    resource do
      base_filter(expr(archived == false))
    end

    postgres do
      base_filter_sql "archived = false"
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story116OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story116Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story116OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story116UserV1)
    end
  end

  defmodule Story116UserV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:archived, :boolean, public?: true, default: false)
      attribute(:hidden, :boolean, public?: true, default: false)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    identities do
      identity(:unique_name, [:name], all_tenants?: true)
    end

    resource do
      base_filter(expr(archived == false and hidden == false))
    end

    postgres do
      base_filter_sql "archived = false AND hidden = false"
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story116OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story116Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story116OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story116UserV2)
    end
  end

  defmodule Story117OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story117UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:archived, :boolean, public?: true, default: false)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    resource do
      base_filter(expr(archived == false))
    end

    postgres do
      base_filter_sql "archived = false"

      custom_indexes do
        index([:name], all_tenants?: true, unique: true, name: "users_active_name_index")
      end
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story117OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story117Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story117OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story117UserV1)
    end
  end

  defmodule Story117UserV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:archived, :boolean, public?: true, default: false)
      attribute(:hidden, :boolean, public?: true, default: false)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    resource do
      base_filter(expr(archived == false and hidden == false))
    end

    postgres do
      base_filter_sql "archived = false AND hidden = false"

      custom_indexes do
        index([:name], all_tenants?: true, unique: true, name: "users_active_name_index")
      end
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story117OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story117Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story117OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story117UserV2)
    end
  end

  defmodule Story118OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
    end
  end

  defmodule Story118UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:email, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:account_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    identities do
      identity(:scoped_name, [:name])
      identity(:global_email, [:email], all_tenants?: true)
    end

    postgres do
      custom_indexes do
        index([:email], all_tenants?: true, name: "users_global_email_index")
      end
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story118OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story118Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story118OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story118UserV1)
    end
  end

  defmodule Story118UserV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:email, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:account_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:account_id)
    end

    identities do
      identity(:scoped_name, [:name])
      identity(:global_email, [:email], all_tenants?: true)
    end

    postgres do
      custom_indexes do
        index([:email], all_tenants?: true, name: "users_global_email_index")
      end
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story118OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story118Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story118OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story118UserV2)
    end
  end

  defmodule Story119OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story119UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:archived, :boolean, public?: true, default: false)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    identities do
      identity(:unique_name, [:name], all_tenants?: true)
    end

    resource do
      base_filter(expr(archived == false))
    end

    postgres do
      base_filter_sql "archived = false"
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story119OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story119Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story119OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story119UserV1)
    end
  end

  defmodule Story119UserV2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
      attribute(:archived, :boolean, public?: true, default: false)
      attribute(:hidden, :boolean, public?: true, default: false)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    identities do
      identity(:unique_name, [:name], all_tenants?: true)
    end

    resource do
      base_filter(expr(archived == false and hidden == false))
    end

    postgres do
      base_filter_sql "archived = false AND hidden = false"
      identity_index_names(unique_name: "renamed_users_unique_name_index")
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story119OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story119Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story119OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story119UserV2)
    end
  end

  defmodule Story120PostV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
      attribute(:foobar, :string, public?: true)
    end
  end

  defmodule Story120Post2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story120PostV1) do
        public?(true)
      end
    end
  end

  defmodule Story120Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story120PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story120Post2V1)
    end
  end

  defmodule Story120Post2V2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "posts"
      repo AshPostgres.TestRepo

      custom_indexes do
        index(["id"])
        index(["id"], unique: true, name: "test_unique_index")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    postgres do
      references do
        reference(:post, name: "special_post_fkey", on_delete: :delete, on_update: :update)
      end
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:name, :string, public?: true)
    end

    relationships do
      belongs_to(:post, AshPostgres.MigrationGeneratorReferencesTest.Story120PostV1) do
        public?(true)
      end
    end
  end

  defmodule Story120Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story120PostV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story120Post2V2)
    end
  end

  defmodule Story121OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story121UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:secondary_id, :uuid, public?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story121OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story121UserThing1V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things1"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      attribute(:id, :string, primary_key?: true, allow_nil?: false, public?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story121OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story121UserV1,
        destination_attribute: :secondary_id,
        public?: true
      )
    end
  end

  defmodule Story121UserThing2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things2"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story121OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story121UserV1) do
        public?(true)
      end
    end
  end

  defmodule Story121Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story121OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story121UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story121UserThing1V1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story121UserThing2V1)
    end
  end

  defmodule Story122OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story122UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story122OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story122UserThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story122OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story122UserV1) do
        public?(true)
        allow_nil?(false)
      end
    end

    postgres do
      references do
        reference(:user, match_tenant?: true)
      end
    end
  end

  defmodule Story122Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story122OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story122UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story122UserThingV1)
    end
  end

  defmodule Story123OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story123UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story123OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story123UserThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story123OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story123UserV1) do
        public?(true)
        allow_nil?(true)
      end
    end

    postgres do
      references do
        reference(:user, match_tenant?: true)
      end
    end
  end

  defmodule Story123Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story123OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story123UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story123UserThingV1)
    end
  end

  defmodule Story124OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story124UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story124OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story124UserThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story124OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story124UserV1) do
        public?(true)
        allow_nil?(true)
      end
    end

    postgres do
      references do
        reference(:user, match_tenant?: true, match_type: :full)
      end
    end
  end

  defmodule Story124Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story124OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story124UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story124UserThingV1)
    end
  end

  defmodule Story125OrgV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "orgs"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story125UserV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "users"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
      attribute(:org_id, :uuid, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story125OrgV1) do
        public?(true)
      end
    end
  end

  defmodule Story125UserThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story125OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story125UserV1) do
        public?(true)
        allow_nil?(false)
      end
    end

    postgres do
      references do
        reference(:user, match_tenant?: true)
      end
    end
  end

  defmodule Story125Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story125OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story125UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story125UserThingV1)
    end
  end

  defmodule Story125NullableUserThingV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "user_things"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id, writable?: true)
      attribute(:name, :string, public?: true)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:org_id)
    end

    relationships do
      belongs_to(:org, AshPostgres.MigrationGeneratorReferencesTest.Story125OrgV1) do
        public?(true)
      end

      belongs_to(:user, AshPostgres.MigrationGeneratorReferencesTest.Story125UserV1) do
        public?(true)
        allow_nil?(true)
      end
    end

    postgres do
      references do
        reference(:user, match_tenant?: true)
      end
    end
  end

  defmodule Story125Domain2 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story125OrgV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story125UserV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story125NullableUserThingV1)
    end
  end

  defmodule Story126TenantV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "tenants"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:id)
    end
  end

  defmodule Story126GroupV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "groups"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:tenant_id)
    end

    relationships do
      belongs_to(:tenant, AshPostgres.MigrationGeneratorReferencesTest.Story126TenantV1)
    end

    postgres do
      references do
        reference(:tenant, on_delete: :delete)
      end
    end
  end

  defmodule Story126ItemV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "items"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    multitenancy do
      strategy(:attribute)
      attribute(:tenant_id)
    end

    relationships do
      belongs_to(:group, AshPostgres.MigrationGeneratorReferencesTest.Story126GroupV1)
      belongs_to(:tenant, AshPostgres.MigrationGeneratorReferencesTest.Story126TenantV1)
    end

    postgres do
      references do
        reference(:group,
          match_with: [tenant_id: :tenant_id],
          on_delete: {:nilify, [:group_id]}
        )

        reference(:tenant, on_delete: :delete)
      end
    end
  end

  defmodule Story126Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story126TenantV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story126GroupV1)
      resource(AshPostgres.MigrationGeneratorReferencesTest.Story126ItemV1)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  defp position_of_substring(string, substring) do
    case :binary.match(string, substring) do
      {position, _length} -> position
      :nomatch -> nil
    end
  end

  @tag story: "US-APMG-101"
  test "references are inferred automatically", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story101Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S[references(:posts, column: :id, name: "posts_post_id_fkey", type: :uuid, prefix: "public")]
  end

  @tag story: "US-APMG-102"
  @tag :issue_236
  test "unique index is created before dependent foreign key (issue #236)", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story102Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    file_contents = File.read!(file)

    unique_index_pos =
      position_of_substring(
        file_contents,
        ~S{create unique_index(:template_phase, [:id], name: "template_phase_id_index")}
      )

    follows_fk_pos = position_of_substring(file_contents, "references(:template_phase")

    assert unique_index_pos && follows_fk_pos,
           "expected migration to contain both the unique index and the follows foreign key"

    assert unique_index_pos < follows_fk_pos,
           "expected unique index creation to appear before the follows foreign key modification"
  end

  @tag story: "US-APMG-103"
  test "references are inferred automatically if the attribute has a different type", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story103Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S[references(:posts, column: :id, name: "posts_post_id_fkey", type: :text, prefix: "public")]
  end

  @tag story: "US-APMG-104"
  test "references allow passing :match_with and :match_type", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story104Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{references(:posts, column: :id, with: [related_key_id: :key_id], match: :partial, name: "posts_post_id_fkey", type: :uuid, prefix: "public")}
  end

  @tag story: "US-APMG-105"
  test "references generate related index when index? true", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story105Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~ ~S{create index(:posts, [:post_id])}
  end

  @tag story: "US-APMG-106"
  test "references generate partial indexes with index_where: :not_nil", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story106Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{create index(:partial_index_comments, [:post_id], where: "post_id IS NOT NULL")}

    assert [snapshot_file] =
             Path.wildcard("#{snapshot_path}/**/partial_index_comments/*.json")

    snapshot = snapshot_file |> File.read!() |> Jason.decode!()
    post_id = Enum.find(snapshot["attributes"], &(&1["source"] == "post_id"))

    assert post_id["references"]["index_where"] == "post_id IS NOT NULL"
  end

  @tag story: "US-APMG-107"
  test "changing only reference index_where replaces the index without changing the foreign key",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story107Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story107Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_, file] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    content = File.read!(file)

    assert content =~ ~S{drop_if_exists index(:index_where_comments, [:post_id])}

    assert content =~
             ~S{create index(:index_where_comments, [:post_id], where: "post_id IS NOT NULL")}

    refute content =~
             ~S{drop constraint(:index_where_comments, "index_where_comments_post_id_fkey")}

    refute content =~ ~S{modify :post_id, references(}
  end

  @tag story: "US-APMG-108"
  test "changing only reference index? does not drop and re-add foreign key (issue #611)", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # First generate: reference with index?: true

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story108Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Second generate: same reference but index?: false (only index change)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story108Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_, file2] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    content = File.read!(file2)

    # Should only drop the index, not touch the foreign key
    assert content =~ ~S{drop_if_exists index(:posts, [:post_id])},
           "migration should drop the reference index when index? changes to false"

    refute content =~ ~S{drop constraint(:posts, "posts_post_id_fkey")},
           "migration should not drop the foreign key when only index? changed (issue #611)"

    refute content =~ ~S{modify :post_id, references(},
           "migration should not modify references when only index? changed (issue #611)"

    refute content =~ ~S{modify :post_id,},
           "migration should not modify the attribute when only index? changes (issue #611)"
  end

  @tag story: "US-APMG-109"
  test "references with deferrable modifications generate changes with the correct schema", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story109Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story109Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(1)
             |> File.read!()

    assert file =~ ~S{execute("ALTER TABLE example.posts ALTER CONSTRAINT}
  end

  @tag story: "US-APMG-110"
  test "index generated by index? true also adds column when using attribute multitenancy", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story110Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~ ~S{create index(:posts, [:org_id, :post_id])}
  end

  @tag story: "US-APMG-111"
  test "index generated by index? true does not duplicate tenant column when using attribute multitenancy if reference is same as tenant column",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story111Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> File.read!()

    assert [up_code, down_code] = String.split(file, "def down do")

    assert up_code =~ ~S{create index(:posts, [:org_id])}
    assert down_code =~ ~S{drop_if_exists index(:posts, [:org_id])}
  end

  @tag story: "US-APMG-112"
  test "transitioning from non-multitenant to attribute multitenancy drops single-column belongs_to indexes and creates composite ones",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story112Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story112Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_first, second] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    content = File.read!(second)

    assert content =~ ~S{drop_if_exists index(:tokens_for_mt_transition, [:user_id])},
           "should drop the obsolete single-column belongs_to index when acquiring multitenancy"

    assert content =~ ~S{create index(:tokens_for_mt_transition, [:org_id, :user_id])},
           "should create the new composite belongs_to index when acquiring multitenancy"
  end

  @tag story: "US-APMG-113"
  test "transitioning from attribute multitenancy to non-multitenant drops composite belongs_to indexes and creates single-column ones",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story113Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story113Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_first, second] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    content = File.read!(second)

    assert content =~ ~S{drop_if_exists index(:tokens_for_mt_drop, [:org_id, :user_id])},
           "should drop the obsolete composite belongs_to index when removing multitenancy"

    assert content =~ ~S{create index(:tokens_for_mt_drop, [:user_id])},
           "should create the new single-column belongs_to index when removing multitenancy"
  end

  @tag story: "US-APMG-114"
  test "references merge :match_with and multitenancy attribute", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story114Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{references(:users, column: :secondary_id, with: [related_key_id: :key_id, org_id: :org_id], match: :full, name: "user_things_user_id_fkey", type: :uuid, prefix: "public")}
  end

  @tag story: "US-APMG-115"
  test "identities using `all_tenants?: true` will not have the condition on multitenancy attribtue added",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story115Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{create unique_index(:users, [:name], name: "users_unique_name_index")}
  end

  @tag story: "US-APMG-116"
  test "when base_filter changes, `all_tenants?: true` identity is dropped and recreated",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story116Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story116Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_first_file, second_file] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    second_contents = File.read!(second_file)

    assert [up_code, _down_code] = String.split(second_contents, "def down do")

    assert up_code =~
             ~S{drop_if_exists unique_index(:users, [:name], name: "users_unique_name_index")}

    assert up_code =~
             ~S{create unique_index(:users, [:name], where: "(archived = false AND hidden = false)"}
  end

  @tag story: "US-APMG-117"
  test "when base_filter changes, `all_tenants?: true` custom index is dropped and recreated",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story117Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story117Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_first_file, second_file] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    second_contents = File.read!(second_file)

    assert [up_code, _down_code] = String.split(second_contents, "def down do")

    assert up_code =~
             ~S{drop_if_exists index(:users, [:name], name: "users_active_name_index")}

    assert up_code =~
             ~S{create index(:users, [:name], name: "users_active_name_index", unique: true, where: "archived = false AND hidden = false")}

    {drop_index, _drop_length} =
      :binary.match(
        up_code,
        ~S{drop_if_exists index(:users, [:name], name: "users_active_name_index")}
      )

    {create_index, _create_length} =
      :binary.match(
        up_code,
        ~S{create index(:users, [:name], name: "users_active_name_index", unique: true, where: "archived = false AND hidden = false")}
      )

    assert drop_index < create_index
  end

  @tag story: "US-APMG-118"
  test "when multitenancy changes, `all_tenants?: true` indexes are not rewritten",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story118Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story118Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_first_file, second_file] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    second_contents = File.read!(second_file)

    assert second_contents =~
             ~S{drop_if_exists unique_index(:users, [:org_id, :name], name: "users_scoped_name_index")}

    refute second_contents =~ ~S{users_global_email_index}
    refute second_contents =~ ~S{users_global_email_unique_index}
  end

  @tag story: "US-APMG-119"
  test "when base_filter and identity index_name change together, only drop and create are emitted",
       %{snapshot_path: snapshot_path, migration_path: migration_path} do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story119Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story119Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_first_file, second_file] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    second_contents = File.read!(second_file)

    assert [up_code, _down_code] = String.split(second_contents, "def down do")

    assert up_code =~
             ~S{drop_if_exists unique_index(:users, [:name], name: "users_unique_name_index")}

    assert up_code =~
             ~S{create unique_index(:users, [:name], where: "(archived = false AND hidden = false)", name: "renamed_users_unique_name_index")}

    refute up_code =~ "ALTER INDEX"
  end

  @tag story: "US-APMG-120"
  test "when modified, the foreign key is dropped before modification", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story120Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story120Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert file =
             "#{migration_path}/**/*_migrate_resources*.exs"
             |> Path.wildcard()
             |> Enum.reject(&String.contains?(&1, "extensions"))
             |> Enum.sort()
             |> Enum.at(1)
             |> File.read!()

    assert file =~
             ~S[references(:posts, column: :id, name: "special_post_fkey", type: :uuid, prefix: "public", on_delete: :delete_all, on_update: :update_all)]

    assert file =~ ~S[drop constraint(:posts, "posts_post_id_fkey")]

    assert [_, down_code] = String.split(file, "def down do")

    assert [_, after_drop] =
             String.split(down_code, "drop constraint(:posts, \"special_post_fkey\")")

    assert after_drop =~ ~S[references(:posts]
  end

  @tag story: "US-APMG-121"
  test "references with added only when needed on multitenant resources", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story121Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{references(:users, column: :secondary_id, with: [org_id: :org_id], match: :full, name: "user_things1_user_id_fkey", type: :uuid, prefix: "public")}

    assert File.read!(file) =~
             ~S[references(:users, column: :id, name: "user_things2_user_id_fkey", type: :uuid, prefix: "public")]
  end

  @tag story: "US-APMG-122"
  test "match_tenant? adds tenant matching on primary key references", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story122Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{references(:users, column: :id, with: [org_id: :org_id], match: :full, name: "user_things_user_id_fkey", type: :uuid, prefix: "public")}
  end

  @tag story: "US-APMG-123"
  test "match_tenant? infers match: :simple on nullable references", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story123Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{references(:users, column: :id, with: [org_id: :org_id], match: :simple, name: "user_things_user_id_fkey", type: :uuid, prefix: "public")}
  end

  @tag story: "US-APMG-124"
  test "match_tenant? honors an explicit match_type", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story124Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S{references(:users, column: :id, with: [org_id: :org_id], match: :full, name: "user_things_user_id_fkey", type: :uuid, prefix: "public")}
  end

  @tag story: "US-APMG-125"
  test "making a match_tenant? reference nullable recreates the foreign key with match: :simple",
       %{
         snapshot_path: snapshot_path,
         migration_path: migration_path
       } do
    # First generate: the reference is required, so it matches with `match: :full`

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story125Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    # Second generate: the same reference, now nullable

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story125Domain2,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    [_, file2] =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()

    content = File.read!(file2)

    assert content =~ ~S{drop constraint(:user_things, "user_things_user_id_fkey")}

    assert content =~
             ~S{modify :user_id, references(:users, column: :id, with: [org_id: :org_id], match: :simple, name: "user_things_user_id_fkey", type: :uuid, prefix: "public"), null: true}
  end

  @tag story: "US-APMG-126"
  test "references on_delete: {:nilify, columns} works with multitenant resources", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Story126Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    assert [file] =
             Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
             |> Enum.reject(&String.contains?(&1, "extensions"))

    assert File.read!(file) =~
             ~S<references(:groups, column: :id, with: [tenant_id: :tenant_id], name: "items_group_id_fkey", type: :uuid, prefix: "public", on_delete: {:nilify, [:group_id]}>
  end
end
