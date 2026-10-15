<!--
SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>

SPDX-License-Identifier: MIT
-->

# Distributed Tables

Distributed PostgreSQL extensions such as [Citus](https://www.citusdata.com/) shard a table across nodes by a *distribution column*. Two distributed tables can only be joined when the join compares their distribution columns, so the planner can push the join down to the shards that hold matching rows. A query that joins them on anything else fails:

```
ERROR: complex joins are only supported when all distributed tables are
co-located and joined on their distribution columns
```

Ash relationships join on `source_attribute` and `destination_attribute` alone (`projects.id = tasks.project_id`), which is rarely the distribution column. Declaring the distribution column on each resource makes `AshPostgres` add the comparison to every join it generates.

## Declaring a distribution key

```elixir
defmodule MyApp.Project do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "projects"
    repo MyApp.Repo
    distribution_key :account_id
  end

  attributes do
    uuid_primary_key :id
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
  end

  relationships do
    has_many :tasks, MyApp.Task
  end
end

defmodule MyApp.Task do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "tasks"
    repo MyApp.Repo
    distribution_key :account_id

    references do
      # Citus also requires foreign keys between distributed tables to include
      # the distribution column. See the references guide for `match_with`.
      reference :project, match_with: [account_id: :account_id], match_type: :full
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
  end

  relationships do
    belongs_to :project, MyApp.Project
  end
end
```

Whenever a join relates two resources that both declare a `distribution_key`, the generated join condition compares the two keys as well:

```sql
SELECT ... FROM "projects" AS p0
INNER JOIN "tasks" AS t1
  ON (p0."id" = t1."project_id") AND (p0."account_id" = t1."account_id")
WHERE (t1."title" = $1)
```

This applies everywhere `AshPostgres` joins through a relationship:

- filtering and sorting on related fields (`Ash.Query.filter(query, tasks.title == "x")`)
- `exists/2` subqueries
- aggregates, including `first`, `list`, and multi-hop aggregates
- relationship loads that use a lateral join (relationships with a `limit`, a `sort` on a `from_many?` `has_one`, and so on)

`many_to_many` relationships get the comparison on both the source-to-through and the through-to-destination joins, so the join resource needs a `distribution_key` as well. Multi-hop paths get it on every hop.

Joins between a resource with a key and one without (a Citus *reference table*, for example) are left exactly as they were. So are relationships with `no_attributes?: true` and manual relationships, which define their own join conditions.

## Instead of a `parent/1` filter

Before this option, the only way to get the comparison into the join was a filter on the relationship:

```elixir
has_many :tasks, MyApp.Task do
  filter expr(parent(account_id) == account_id)
end
```

That has two drawbacks. A `parent/1` expression forces every join of that relationship into a lateral join, and `manage_relationship` cannot look up existing related records through such a relationship, since there is no parent record to resolve `parent/1` against during the lookup. With `distribution_key` declared, the relationship needs no filter: joins stay plain joins, and `manage_relationship` lookups work as usual.

## Attribute multitenancy

The distribution key is usually also the multitenancy attribute. The two are independent: with a tenant set, `AshPostgres` still adds the tenant filter (`t1."account_id" = $1`) to joined resources, and the distribution key adds the join comparison. Declare both.
