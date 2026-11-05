# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DeltaModeConstraintsTest do
  use ExUnit.Case, async: true
  import AshPostgres.Test.DeltaModeHelpers
  alias AshPostgres.MigrationGenerator.Operation
  @moduletag :migration
  @moduletag :tmp_dir

  defmodule Story011DeltaAuthorV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_authors")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:email, :string, public?: true)
    end

    identities do
      identity(:unique_email, [:email])
    end
  end

  defmodule Story011Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeConstraintsTest.Story011DeltaAuthorV1)
    end
  end

  defmodule Story012DeltaProductV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_products")
      repo(AshPostgres.TestRepo)

      custom_indexes do
        index(["title"], name: "delta_products_title_idx")
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

  defmodule Story012Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeConstraintsTest.Story012DeltaProductV1)
    end
  end

  defmodule Story013DeltaInvoiceV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_invoices")
      repo(AshPostgres.TestRepo)

      check_constraints do
        check_constraint(:amount, "positive_amount", check: "amount > 0")
      end
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:amount, :integer, public?: true)
    end
  end

  defmodule Story013Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeConstraintsTest.Story013DeltaInvoiceV1)
    end
  end

  defmodule Story014DeltaAuthor2V1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_authors_2")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end
  end

  defmodule Story014DeltaPost2RefV1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table("delta_posts_with_ref")
      repo(AshPostgres.TestRepo)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    relationships do
      belongs_to(:author, AshPostgres.DeltaModeConstraintsTest.Story014DeltaAuthor2V1,
        public?: true,
        allow_nil?: false
      )
    end
  end

  defmodule Story014Domain1 do
    use Ash.Domain

    resources do
      resource(AshPostgres.DeltaModeConstraintsTest.Story014DeltaAuthor2V1)
      resource(AshPostgres.DeltaModeConstraintsTest.Story014DeltaPost2RefV1)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations"),
      tenant_migration_path: Path.join(tmp_dir, "tenant_migrations"),
      full_sp: Path.join(tmp_dir, "full/snapshots"),
      full_mp: Path.join(tmp_dir, "full/migrations"),
      delta_sp: Path.join(tmp_dir, "delta/snapshots"),
      delta_mp: Path.join(tmp_dir, "delta/migrations")
    }
  end

  describe "identities, indexes, constraints, references" do
    @tag story: "US-APDI-011"
    test "adding an identity (unique constraint) produces AddUniqueIndex ops", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story011Domain1, sp, mp)

      [file] = delta_files(sp, "delta_authors")
      delta = read_delta(file)

      unique_indexes = ops_of_type(delta, Operation.AddUniqueIndex)

      assert Enum.any?(unique_indexes, fn op ->
               op.identity.name == :unique_email and op.identity.keys == [:email]
             end)

      # Reducer tracks the identity
      state = reduce_dir(sp, "delta_authors")
      assert Enum.any?(state.identities, &(&1.name == :unique_email))
    end

    @tag story: "US-APDI-012"
    test "adding a custom index produces an AddCustomIndex op", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story012Domain1, sp, mp)

      [file] = delta_files(sp, "delta_products")
      delta = read_delta(file)

      custom_indexes = ops_of_type(delta, Operation.AddCustomIndex)

      assert Enum.any?(custom_indexes, fn op ->
               op.index.name == "delta_products_title_idx"
             end)

      state = reduce_dir(sp, "delta_products")
      assert Enum.any?(state.custom_indexes, &(&1.name == "delta_products_title_idx"))
    end

    @tag story: "US-APDI-013"
    test "adding a check constraint produces an AddCheckConstraint op", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story013Domain1, sp, mp)

      [file] = delta_files(sp, "delta_invoices")
      delta = read_delta(file)

      checks = ops_of_type(delta, Operation.AddCheckConstraint)

      assert Enum.any?(checks, fn op ->
               op.constraint.name == "positive_amount" and op.constraint.check == "amount > 0"
             end)

      state = reduce_dir(sp, "delta_invoices")
      assert Enum.any?(state.check_constraints, &(&1.name == "positive_amount"))
    end

    @tag story: "US-APDI-014"
    test "references (belongs_to) round-trip through delta encode + reduce", %{
      snapshot_path: sp,
      migration_path: mp
    } do
      run_codegen(Story014Domain1, sp, mp)

      [delta_file] = delta_files(sp, "delta_posts_with_ref")
      delta = read_delta(delta_file)

      # The generator emits: AddAttribute (references=nil) → AlterAttribute
      # (adds the FK). So the reference info lives on the AlterAttribute op's
      # new_attribute, not the AddAttribute.
      adds = ops_of_type(delta, Operation.AddAttribute)
      assert Enum.any?(adds, &(&1.attribute.source == :author_id))

      alters = ops_of_type(delta, Operation.AlterAttribute)

      author_alter =
        Enum.find(alters, fn op -> op.new_attribute.source == :author_id end)

      assert author_alter != nil
      assert is_map(author_alter.new_attribute.references)
      assert author_alter.new_attribute.references.table == "delta_authors_2"
      assert author_alter.new_attribute.references.destination_attribute == :id

      # End-to-end: the reducer propagates the reference into state.
      state = reduce_dir(sp, "delta_posts_with_ref")

      reduced_ref =
        state.attributes
        |> Enum.find(&(&1.source == :author_id))
        |> Map.get(:references)

      assert reduced_ref.table == "delta_authors_2"
      assert reduced_ref.destination_attribute == :id
    end
  end
end
