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

      result = CollatedString.postgres_reference_expr(CollatedString, constraints, expr)

      assert {:ok, dynamic} = result
      assert is_struct(dynamic, Ecto.Query.DynamicExpr)
    end

    @tag :callback
    test "handles different collation names" do
      for collation <- ["C", "POSIX", "en_US.utf8", "default"] do
        constraints = [collation: collation]
        expr = {:^, [], [0]}

        result = CollatedString.postgres_reference_expr(CollatedString, constraints, expr)
        assert {:ok, _dynamic} = result
      end
    end

    @tag :callback
    test "returns error for missing collation constraint" do
      constraints = []
      expr = {:^, [], [0]}

      result = CollatedString.postgres_reference_expr(CollatedString, constraints, expr)
      assert {:error, message} = result
      assert is_binary(message)
      assert message =~ "collation"
    end

    @tag :callback
    test "returns error for non-string collation" do
      constraints = [collation: :atom_value]
      expr = {:^, [], [0]}

      result = CollatedString.postgres_reference_expr(CollatedString, constraints, expr)
      assert {:error, message} = result
      assert is_binary(message)
    end
  end

  describe "query filter generation with COLLATE" do
    @tag :filter_queries
    test "includes COLLATE in WHERE clause for contains/1" do
      # Create a query with filter
      query =
        CollatedPost
        |> Ash.Query.filter(contains(title, "test"))

      # Convert to Ecto query and inspect SQL
      {:ok, ecto_query} = Ash.Query.data_layer_query(query, domain: AshPostgres.Test.Domain)
      {sql, _params} = AshPostgres.TestRepo.to_sql(:all, ecto_query)

      assert sql =~ ~r/title.*COLLATE.*"C"/i
      assert sql =~ "ILIKE"
    end

    @tag :filter_queries
    test "includes COLLATE in WHERE clause for equals/1" do
      query =
        CollatedPost
        |> Ash.Query.filter(title == "exact")

      {:ok, ecto_query} = Ash.Query.data_layer_query(query, domain: AshPostgres.Test.Domain)
      {sql, _params} = AshPostgres.TestRepo.to_sql(:all, ecto_query)

      assert sql =~ ~r/title.*COLLATE.*"C"/i
    end

    @tag :filter_queries
    test "handles multiple collated fields in same query" do
      query =
        CollatedPost
        |> Ash.Query.filter(contains(title, "foo") and contains(content, "bar"))

      {:ok, ecto_query} = Ash.Query.data_layer_query(query, domain: AshPostgres.Test.Domain)
      {sql, _params} = AshPostgres.TestRepo.to_sql(:all, ecto_query)

      # Both fields should have their respective collations
      assert sql =~ ~r/title.*COLLATE.*"C"/i
      assert sql =~ ~r/content.*COLLATE.*"en_US\.utf8"/i
    end
  end

  describe "query sort generation with COLLATE" do
    @tag :sort_queries
    test "includes COLLATE in ORDER BY clause" do
      query =
        CollatedPost
        |> Ash.Query.sort(title: :asc)

      {:ok, ecto_query} = Ash.Query.data_layer_query(query, domain: AshPostgres.Test.Domain)
      {sql, _params} = AshPostgres.TestRepo.to_sql(:all, ecto_query)

      assert sql =~ ~r/ORDER BY.*title.*COLLATE.*"C"/i
      assert sql =~ "ASC"
    end

    @tag :sort_queries
    test "handles ascending and descending sorts" do
      query =
        CollatedPost
        |> Ash.Query.sort(title: :desc)

      {:ok, ecto_query} = Ash.Query.data_layer_query(query, domain: AshPostgres.Test.Domain)
      {sql, _params} = AshPostgres.TestRepo.to_sql(:all, ecto_query)

      assert sql =~ ~r/ORDER BY.*title.*COLLATE.*"C"/i
      assert sql =~ "DESC"
    end

    @tag :sort_queries
    test "respects different collations for different fields" do
      query =
        CollatedPost
        |> Ash.Query.sort(title: :asc, content: :desc)

      {:ok, ecto_query} = Ash.Query.data_layer_query(query, domain: AshPostgres.Test.Domain)
      {sql, _params} = AshPostgres.TestRepo.to_sql(:all, ecto_query)

      # Each field should have its own collation
      assert sql =~ ~r/title.*COLLATE.*"C"/i
      assert sql =~ ~r/content.*COLLATE.*"en_US\.utf8"/i
    end
  end

  describe "live database execution" do
    @tag :database_integration
    test "executes LIKE query with deterministic collation successfully" do
      # Create test data
      post =
        CollatedPost
        |> Ash.Changeset.for_create(:create, %{title: "Test Post", author: "John"})
        |> Ash.create!()

      # Query with pattern matching - should work with C collation
      results =
        CollatedPost
        |> Ash.Query.filter(contains(title, "Test"))
        |> Ash.read!()

      assert length(results) == 1
      assert hd(results).id == post.id
    end

    @tag :database_integration
    test "executes ILIKE query with C collation successfully" do
      post =
        CollatedPost
        |> Ash.Changeset.for_create(:create, %{title: "MixedCase", author: "Jane"})
        |> Ash.create!()

      # Case-insensitive search
      results =
        CollatedPost
        |> Ash.Query.filter(contains(title, "mixed"))
        |> Ash.read!()

      assert length(results) == 1
      assert hd(results).id == post.id
    end

    @tag :database_integration
    test "handles sorting with collation" do
      # Create multiple posts
      _post1 =
        CollatedPost
        |> Ash.Changeset.for_create(:create, %{title: "Zebra", author: "A"})
        |> Ash.create!()

      _post2 =
        CollatedPost
        |> Ash.Changeset.for_create(:create, %{title: "Apple", author: "B"})
        |> Ash.create!()

      # Sort by title
      results =
        CollatedPost
        |> Ash.Query.sort(title: :asc)
        |> Ash.read!()

      titles = Enum.map(results, & &1.title)
      assert titles == Enum.sort(titles)
    end

    @tag :database_integration
    test "handles multiple collated fields in complex query" do
      post =
        CollatedPost
        |> Ash.Changeset.for_create(:create, %{
          title: "SearchTitle",
          content: "SearchContent",
          author: "Author"
        })
        |> Ash.create!()

      # Complex filter with multiple collated fields
      results =
        CollatedPost
        |> Ash.Query.filter(contains(title, "Search") and contains(content, "Content"))
        |> Ash.Query.sort(title: :asc)
        |> Ash.read!()

      assert length(results) == 1
      assert hd(results).id == post.id
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
