# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.Verifiers.ValidateDistributionKey do
  @moduledoc false
  use Spark.Dsl.Verifier
  alias Spark.Dsl.Verifier

  def verify(dsl) do
    case AshPostgres.DataLayer.Info.distribution_key(dsl) do
      nil ->
        :ok

      key ->
        if Ash.Resource.Info.attribute(dsl, key) do
          :ok
        else
          raise Spark.Error.DslError,
            path: [:postgres, :distribution_key],
            module: Verifier.get_persisted(dsl, :module),
            message: """
            The distribution key #{inspect(key)} is not an attribute of this resource.
            """,
            location: Spark.Dsl.Transformer.get_opt_anno(dsl, [:postgres], :distribution_key)
        end
    end
  end
end
