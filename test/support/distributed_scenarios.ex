# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Test.DistributedScenarios do
  @moduledoc """
  Query scenarios over the `AshPostgres.Test.Distributed.*` resources.

  `use`d by both `AshPostgres.DistributionKeyTest` (plain PostgreSQL) and
  `AshPostgres.CitusTest`, so the same scenarios run on a server that merely tolerates the
  extra join condition and on one that requires it. Each scenario is a function taking the
  seeded context, and `use` defines one test per scenario.
  """

  import ExUnit.Assertions

  require Ash.Query

  alias AshPostgres.Test.Distributed.Comment
  alias AshPostgres.Test.Distributed.Project
  alias AshPostgres.Test.Distributed.ProjectTag
  alias AshPostgres.Test.Distributed.Tag
  alias AshPostgres.Test.Distributed.Task

  @scenarios [
    filters_through_a_belongs_to: "filters through a belongs_to",
    filters_through_a_has_many: "filters through a has_many",
    filters_through_a_many_to_many: "filters through a many_to_many",
    filters_through_multiple_hops: "filters through multiple hops",
    filters_with_exists: "filters with exists",
    filters_through_limited_relationships:
      "filters through a from_many? has_one and a limited has_many",
    loads_aggregates: "loads aggregates",
    filters_and_sorts_by_aggregates: "filters and sorts by aggregates",
    loads_relationships: "loads relationships",
    loads_relationships_scoped_to_a_tenant: "loads relationships scoped to a tenant",
    manages_relationships:
      "manage_relationship can look up a related record without a parent() filter"
  ]

  defmacro __using__(_opts) do
    tests =
      for {function, name} <- @scenarios do
        quote do
          test unquote(name), context do
            unquote(__MODULE__).unquote(function)(context)
          end
        end
      end

    quote do
      setup do
        unquote(__MODULE__).seed()
      end

      unquote_splicing(tests)
    end
  end

  @doc "Seeds two accounts' worth of projects, tasks, comments and tags"
  def seed do
    account = Ash.UUID.generate()
    other_account = Ash.UUID.generate()

    project = Ash.create!(Project, %{account_id: account, name: "alpha"})
    other_project = Ash.create!(Project, %{account_id: other_account, name: "alpha"})

    task_a = Ash.create!(Task, %{account_id: account, project_id: project.id, title: "a"})
    task_b = Ash.create!(Task, %{account_id: account, project_id: project.id, title: "b"})
    Ash.create!(Task, %{account_id: account, project_id: project.id, title: "c"})
    Ash.create!(Task, %{account_id: other_account, project_id: other_project.id, title: "z"})

    Ash.create!(Comment, %{account_id: account, task_id: task_a.id, body: "one"})
    Ash.create!(Comment, %{account_id: account, task_id: task_b.id, body: "two"})

    tag = Ash.create!(Tag, %{account_id: account, name: "urgent"})
    spare_tag = Ash.create!(Tag, %{account_id: account, name: "spare"})
    Ash.create!(ProjectTag, %{account_id: account, project_id: project.id, tag_id: tag.id})

    other_tag = Ash.create!(Tag, %{account_id: other_account, name: "later"})

    Ash.create!(ProjectTag, %{
      account_id: other_account,
      project_id: other_project.id,
      tag_id: other_tag.id
    })

    %{
      account: account,
      other_account: other_account,
      project: project,
      other_project: other_project,
      task_a: task_a,
      tag: tag,
      spare_tag: spare_tag,
      other_tag: other_tag
    }
  end

  def filters_through_a_belongs_to(%{account: account}) do
    assert ["a", "b", "c", "z"] =
             Task
             |> Ash.Query.filter(project.name == "alpha")
             |> Ash.Query.sort(:title)
             |> Ash.read!()
             |> Enum.map(& &1.title)

    assert ["a", "b", "c"] =
             Task
             |> Ash.Query.set_tenant(account)
             |> Ash.Query.filter(project.name == "alpha")
             |> Ash.Query.sort(:title)
             |> Ash.read!()
             |> Enum.map(& &1.title)
  end

  def filters_through_a_has_many(%{project: project}) do
    assert [%{id: id}] = Project |> Ash.Query.filter(tasks.title == "a") |> Ash.read!()
    assert id == project.id
  end

  def filters_through_a_many_to_many(%{project: project, other_project: other_project}) do
    assert [%{id: id}] = Project |> Ash.Query.filter(tags.name == "urgent") |> Ash.read!()
    assert id == project.id

    assert [%{id: id}] = Project |> Ash.Query.filter(tags.name == "later") |> Ash.read!()
    assert id == other_project.id

    assert [%{id: id}] =
             Tag |> Ash.Query.filter(projects.name == "alpha" and name == "urgent") |> Ash.read!()

    assert id != other_project.id
  end

  def filters_through_multiple_hops(%{project: project}) do
    assert [%{id: id}] = Project |> Ash.Query.filter(tasks.comments.body == "two") |> Ash.read!()
    assert id == project.id
    assert [] = Project |> Ash.Query.filter(tasks.comments.body == "none") |> Ash.read!()
  end

  def filters_with_exists(%{project: project}) do
    assert [%{id: id}] = Project |> Ash.Query.filter(exists(tasks, title == "c")) |> Ash.read!()
    assert id == project.id

    assert [%{id: ^id}] =
             Project |> Ash.Query.filter(exists(tasks.comments, body == "one")) |> Ash.read!()

    assert [%{id: ^id}] =
             Project |> Ash.Query.filter(exists(tags, name == "urgent")) |> Ash.read!()

    assert [] = Project |> Ash.Query.filter(exists(tags, name == "nope")) |> Ash.read!()
  end

  def filters_through_limited_relationships(%{project: project}) do
    assert [%{id: id}] = Project |> Ash.Query.filter(latest_task.title == "c") |> Ash.read!()
    assert id == project.id
    assert [] = Project |> Ash.Query.filter(latest_task.title == "a") |> Ash.read!()

    assert [%{id: ^id}] =
             Project |> Ash.Query.filter(first_two_tasks.title == "b") |> Ash.read!()

    assert [] = Project |> Ash.Query.filter(first_two_tasks.title == "c") |> Ash.read!()
  end

  def loads_aggregates(%{project: project, other_project: other_project}) do
    project =
      Ash.load!(project, [
        :task_count,
        :comment_count,
        :has_tasks,
        :first_task_title,
        :task_titles,
        :tag_count,
        :tag_names
      ])

    assert project.task_count == 3
    assert project.comment_count == 2
    assert project.has_tasks
    assert project.first_task_title == "a"
    assert project.task_titles == ["a", "b", "c"]
    assert project.tag_count == 1
    assert project.tag_names == ["urgent"]

    other_project = Ash.load!(other_project, [:task_count, :comment_count, :tag_names])
    assert other_project.task_count == 1
    assert other_project.comment_count == 0
    assert other_project.tag_names == ["later"]

    assert ["a", "b", "c", "z"] =
             Task
             |> Ash.Query.sort(:title)
             |> Ash.Query.load([:project_name, :comment_count])
             |> Ash.read!()
             |> Enum.map(fn task ->
               assert task.project_name == "alpha"
               task.title
             end)

    assert [%{comment_count: 1}, %{comment_count: 1}, %{comment_count: 0}, %{comment_count: 0}] =
             Task |> Ash.Query.sort(:title) |> Ash.Query.load(:comment_count) |> Ash.read!()
  end

  def filters_and_sorts_by_aggregates(%{
        account: account,
        project: project,
        other_tag: other_tag
      }) do
    assert [%{id: id}] = Project |> Ash.Query.filter(task_count == 3) |> Ash.read!()
    assert id == project.id

    assert [%{id: id}] =
             Tag |> Ash.Query.filter(project_count == 1 and name == "later") |> Ash.read!()

    assert id == other_tag.id

    Ash.update!(Ash.get!(Project, id: project.id, account_id: account), %{name: "zulu"})

    assert ["z", "a", "b", "c"] =
             Task
             |> Ash.Query.sort(project_name: :asc, title: :asc)
             |> Ash.read!()
             |> Enum.map(& &1.title)
  end

  def loads_relationships(%{project: project, task_a: task_a}) do
    project = Ash.load!(project, [:tasks, :tags, :latest_task, :first_two_tasks])

    assert ["a", "b", "c"] = project.tasks |> Enum.map(& &1.title) |> Enum.sort()
    assert ["urgent"] = Enum.map(project.tags, & &1.name)
    assert project.latest_task.title == "c"
    assert ["a", "b"] = Enum.map(project.first_two_tasks, & &1.title)

    task_a = Ash.load!(task_a, [:project, :comments])
    assert task_a.project.id == project.id
    assert ["one"] = Enum.map(task_a.comments, & &1.body)

    assert [%{tasks: [_]}, %{tasks: [_, _, _]}] =
             Project
             |> Ash.Query.load(:tasks)
             |> Ash.read!()
             |> Enum.sort_by(&length(&1.tasks))

    assert [%{tags: [%{name: "later"}]}, %{tags: [%{name: "urgent"}]}] =
             Project
             |> Ash.Query.load(:tags)
             |> Ash.read!()
             |> Enum.sort_by(&hd(&1.tags).name)
  end

  def loads_relationships_scoped_to_a_tenant(%{account: account, project: project}) do
    assert [%{id: id, tasks: tasks, tags: [%{name: "urgent"}], task_count: 3} = loaded] =
             Project
             |> Ash.Query.set_tenant(account)
             |> Ash.Query.load([:tasks, :tags, :latest_task, :task_count])
             |> Ash.read!()

    assert id == project.id
    assert length(tasks) == 3
    assert loaded.latest_task.title == "c"
  end

  def manages_relationships(%{account: account, project: project, spare_tag: spare_tag}) do
    project =
      project
      |> Ash.Changeset.for_update(
        :add_tags,
        %{tags: [%{id: spare_tag.id, account_id: account}]},
        tenant: account
      )
      |> Ash.update!()
      |> Ash.load!(:tags)

    assert ["spare", "urgent"] = project.tags |> Enum.map(& &1.name) |> Enum.sort()
  end
end
