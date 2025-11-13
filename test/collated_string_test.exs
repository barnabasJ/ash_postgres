# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.CollatedStringTest do
  use AshPostgres.RepoCase, async: true

  alias AshPostgres.CollatedString
  alias AshPostgres.CollationTestHelpers
  alias AshPostgres.Test.CollatedPost

  require Ash.Query

  describe "type instantiation" do
    @tag :type_instantiation
    test "type exists and is loadable" do
      assert Code.ensure_loaded?(CollatedString)
    end

    @tag :type_instantiation
    test "storage type is :text" do
      assert :text = CollatedString.storage_type(collation: "C")
    end

    @tag :type_instantiation
    test "requires collation constraint" do
      # Constraint validation happens at compile time via Spark
      # This test verifies the constraint is defined
      constraints = CollatedString.constraints()
      assert Keyword.has_key?(constraints, :collation)
      collation_constraint = constraints[:collation]
      assert collation_constraint[:required] == true
      assert collation_constraint[:type] == :string
    end

    @tag :type_instantiation
    test "rejects invalid collation constraint type" do
      # Constraint validation would happen at compile time
      # This test verifies the constraint type is :string
      constraints = CollatedString.constraints()
      collation_constraint = constraints[:collation]
      assert collation_constraint[:type] == :string
    end
  end

  describe "postgres_reference_expr callback" do
    @tag :callback
    test "wraps column reference with COLLATE clause" do
      collation = "C"
      constraints = [collation: collation]

      # Simulate a column reference (would come from Ecto.Query)
      expr = {:^, [], [0]}

      result = CollatedString.postgres_reference_expr(expr, constraints, nil)

      assert {:ok, dynamic} = result
      assert is_struct(dynamic, Ecto.Query.DynamicExpr)
    end

    @tag :callback
    test "handles different collation names" do
      for collation <- ["C", "POSIX", "en_US.utf8", "default"] do
        constraints = [collation: collation]
        expr = {:^, [], [0]}

        result = CollatedString.postgres_reference_expr(expr, constraints, nil)
        assert {:ok, _dynamic} = result
      end
    end

    @tag :callback
    test "returns error for missing collation constraint" do
      constraints = []
      expr = {:^, [], [0]}

      result = CollatedString.postgres_reference_expr(expr, constraints, nil)
      assert {:error, message} = result
      assert is_binary(message)
      assert message =~ "collation"
    end

    @tag :callback
    test "returns error for non-string collation" do
      constraints = [collation: :atom_value]
      expr = {:^, [], [0]}

      result = CollatedString.postgres_reference_expr(expr, constraints, nil)
      assert {:error, message} = result
      assert is_binary(message)
    end
  end

  describe "database collation availability" do
    @tag :collation_availability
    test "lists available PostgreSQL collations" do
      collations = CollationTestHelpers.available_collations()
      assert is_list(collations)
      assert length(collations) > 0
    end

    @tag :collation_availability
    test "verifies required collations exist" do
      assert CollationTestHelpers.collation_exists?("C")
      assert CollationTestHelpers.collation_exists?("POSIX")
      # Note: en_US.utf8 may not be available on all systems
    end
  end
end
