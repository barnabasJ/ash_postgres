# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.DistributionKeyTest do
  use AshPostgres.RepoCase, async: false
  use AshPostgres.Test.DistributedScenarios

  require Ash.Query

  alias AshPostgres.Test.Comment, as: PlainComment
  alias AshPostgres.Test.Distributed.Project
  alias AshPostgres.Test.Distributed.Task
  alias AshPostgres.Test.Post, as: PlainPost

  defp sql(query) do
    {sql, _} =
      query
      |> Ash.data_layer_query!()
      |> Map.get(:query)
      |> then(&AshPostgres.TestRepo.to_sql(:all, &1))

    sql
  end

  describe "generated SQL" do
    test "a belongs_to join compares the distribution keys" do
      assert sql(Ash.Query.filter(Task, project.name == "x")) =~
               ~s{ON (d0."project_id" = d1."id") AND (d0."account_id" = d1."account_id")}
    end

    test "a has_many join compares the distribution keys" do
      assert sql(Ash.Query.filter(Project, tasks.title == "x")) =~
               ~s{ON (d0."id" = d1."project_id") AND (d0."account_id" = d1."account_id")}
    end

    test "a many_to_many join compares the distribution keys on both hops" do
      sql = sql(Ash.Query.filter(Project, tags.name == "x"))

      assert sql =~ ~s{ON (d0."id" = d1."project_id") AND (d0."account_id" = d1."account_id")}
      assert sql =~ ~s{ON (d2."id" = d1."tag_id") AND (d1."account_id" = d2."account_id")}
    end

    test "a multi-hop join compares the distribution keys on every hop" do
      sql = sql(Ash.Query.filter(Project, tasks.comments.body == "x"))

      assert sql =~ ~s{ON (d0."id" = d1."project_id") AND (d0."account_id" = d1."account_id")}
      assert sql =~ ~s{ON (d1."id" = d2."task_id") AND (d1."account_id" = d2."account_id")}
    end

    test "an exists subquery correlates on the distribution keys" do
      assert sql(Ash.Query.filter(Project, exists(tasks, title == "x"))) =~
               ~s{(d0."id" = sd0."project_id") AND (d0."account_id" = sd0."account_id")}

      sql = sql(Ash.Query.filter(Project, exists(tags, name == "x")))

      assert sql =~ ~s{(sd1."tag_id" = sd0."id")}
      assert sql =~ ~s{(sd1."account_id" = sd0."account_id")}
      assert sql =~ ~s{(d0."id" = sd1."project_id")}
      assert sql =~ ~s{(d0."account_id" = sd1."account_id")}
    end

    test "a from_many? has_one is correlated on the distribution keys" do
      sql = sql(Ash.Query.filter(Project, latest_task.title == "x"))

      assert sql =~ "LATERAL"
      assert sql =~ ~s{(d0."id" = sd0."project_id") AND (d0."account_id" = sd0."account_id")}
    end

    test "lateral aggregates correlate on the distribution keys" do
      sql = sql(Ash.Query.load(Project, [:task_count, :first_task_title, :task_titles]))

      assert sql =~ ~s{(d0."id" = sd0."project_id") AND (d0."account_id" = sd0."account_id")}
      assert sql =~ ~s{(d0."id" = ssd0."project_id") AND (d0."account_id" = ssd0."account_id")}
    end

    test "many_to_many aggregates compare the distribution keys on both hops" do
      sql = sql(Ash.Query.load(Project, :tag_count))

      assert sql =~ ~s{ON (sd1."tag_id" = sd0."id") AND (sd1."account_id" = sd0."account_id")}
      assert sql =~ ~s{(d0."id" = sd1."project_id") AND (d0."account_id" = sd1."account_id")}
    end

    test "multi-hop aggregates compare the distribution keys on every hop" do
      sql = sql(Ash.Query.load(Project, :comment_count))

      assert sql =~ ~s{ON (sd0."id" = sd1."task_id") AND (sd0."account_id" = sd1."account_id")}
      assert sql =~ ~s{(d0."id" = sd0."project_id") AND (d0."account_id" = sd0."account_id")}
    end

    test "the tenant filter still applies alongside the distribution key", %{account: account} do
      sql = sql(Task |> Ash.Query.set_tenant(account) |> Ash.Query.filter(project.name == "x"))

      # the tenant filter wraps the joined resource in a subquery
      assert sql =~ ~s{ON (d0."project_id" = s1."id") AND (d0."account_id" = s1."account_id")}
      assert sql =~ ~s{sd0."account_id"::uuid = $1::uuid}
    end

    test "resources without a distribution key are joined on the relationship attributes only" do
      sql = sql(Ash.Query.filter(PlainPost, comments.title == "x"))

      assert sql =~ ~s{ON p0."id" = c1."post_id" WHERE}
      refute sql =~ "account_id"

      assert sql(Ash.Query.filter(PlainComment, post.title == "x")) =~
               ~s{ON c0."post_id" = s1."id" WHERE}
    end
  end

  describe "verification" do
    test "the distribution key must be an attribute of the resource" do
      # Spark reports a verifier's `DslError` as a compile warning
      warning =
        ExUnit.CaptureIO.capture_io(:stderr, fn ->
          defmodule BadDistributionKey do
            use Ash.Resource,
              domain: nil,
              validate_domain_inclusion?: false,
              data_layer: AshPostgres.DataLayer

            postgres do
              table("bad_distribution_key")
              repo(AshPostgres.TestRepo)
              distribution_key(:nope)
            end

            attributes do
              uuid_primary_key(:id)
            end
          end
        end)

      assert warning =~ "Spark.Error.DslError"
      assert warning =~ "postgres -> distribution_key"
      assert warning =~ "The distribution key :nope is not an attribute of this resource"
    end
  end
end
