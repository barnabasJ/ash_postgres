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
    test "accepts valid collation constraint" do
      assert :text = CollatedString.storage_type(collation: "C")
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
