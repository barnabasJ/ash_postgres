# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MapFieldTypeExprTest do
  @moduledoc false
  use AshPostgres.RepoCase, async: true

  alias AshPostgres.Test.Post

  require Ash.Query

  setup do
    post =
      Post
      |> Ash.Changeset.for_create(:create, %{
        title: "a",
        keyword_map: [display_template: "{{foo}}", size: 3]
      })
      |> Ash.create!()

    %{post: post}
  end

  @tag story: "US-APMAP-01"
  test "a field declared an integer is compared as an integer", %{post: post} do
    # Given the stored map contains a declared integer field.
    # When the public query compares that field with an integer.
    assert [found] =
             Post
             |> Ash.Query.filter(keyword_map[:size] == 3)
             |> Ash.read!()

    # Then the query returns the stored record.
    assert found.id == post.id
  end

  @tag story: "US-APMAP-02"
  test "a field declared an integer orders numerically" do
    # Given two stored maps contain the integer values three and ten.
    Post
    |> Ash.Changeset.for_create(:create, %{
      title: "b",
      keyword_map: [display_template: "{{bar}}", size: 10]
    })
    |> Ash.create!()

    # When the query compares their integer field with nine.
    # Then only the numerically greater value matches.
    assert [%{keyword_map: [display_template: "{{bar}}", size: 10]}] =
             Post
             |> Ash.Query.filter(keyword_map[:size] > 9)
             |> Ash.read!()
  end

  @tag story: "US-APMAP-03"
  test "a field declared a string still compares as a string", %{post: post} do
    # Given the stored map contains a declared string field.
    # When the public query compares the exact string value.
    assert [found] =
             Post
             |> Ash.Query.filter(keyword_map[:display_template] == "{{foo}}")
             |> Ash.read!()

    # Then the query returns the stored record.
    assert found.id == post.id
  end
end
