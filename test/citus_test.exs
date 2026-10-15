# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.CitusTest do
  @moduledoc """
  Runs the distributed query scenarios against Citus, which rejects a join between two
  distributed tables unless it compares their distribution columns.

  Excluded by default. To run it, start a Citus server, point the test repo at it and
  include the tag:

      docker run -d --name ash_citus -p 5433:5432 \\
        -e POSTGRES_HOST_AUTH_METHOD=trust citusdata/citus:13.0
      PG_PORT=5433 mix test.create
      PG_PORT=5433 mix test.migrate
      PG_PORT=5433 mix test --include citus test/citus_test.exs
  """
  use AshPostgres.RepoCase, async: false

  @moduletag :citus

  # Foreign keys point at earlier tables, and Citus requires the referenced table to be
  # distributed first.
  @tables ~w(distributed_projects distributed_tags distributed_tasks distributed_comments distributed_project_tags)

  setup_all do
    Ecto.Adapters.SQL.Sandbox.unboxed_run(TestRepo, fn ->
      TestRepo.query!("CREATE EXTENSION IF NOT EXISTS citus")

      for table <- @tables do
        %{rows: rows} =
          TestRepo.query!(
            "SELECT 1 FROM pg_dist_partition WHERE logicalrelid = '#{table}'::regclass"
          )

        if rows == [] do
          TestRepo.query!("SELECT create_distributed_table('#{table}', 'account_id')")
        end
      end
    end)

    :ok
  end

  test "citus rejects a join between distributed tables that lacks the distribution key" do
    assert {:error, %Postgrex.Error{postgres: %{message: message}}} =
             TestRepo.query("""
             SELECT count(*)
             FROM distributed_projects AS p
             JOIN distributed_tasks AS t ON t.project_id = p.id
             """)

    assert message =~ "distribution column" or message =~ "repartition"
  end

  use AshPostgres.Test.DistributedScenarios
end
