# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.CollationTestHelpers do
  @moduledoc """
  Helper functions for testing PostgreSQL collation support.
  """

  @doc """
  Returns a list of all collations available in the test database.

  ## Examples

      iex> available_collations()
      ["C", "POSIX", "en_US.utf8", "default", ...]
  """
  def available_collations do
    query = """
    SELECT collname FROM pg_collation
    ORDER BY collname
    """

    case AshPostgres.TestRepo.query(query) do
      {:ok, %{rows: rows}} -> Enum.map(rows, fn [name] -> name end)
      _ -> []
    end
  end

  @doc """
  Checks if a specific collation is available in the database.

  ## Examples

      iex> collation_exists?("C")
      true

      iex> collation_exists?("nonexistent")
      false
  """
  def collation_exists?(collation_name) when is_binary(collation_name) do
    collation_name in available_collations()
  end
end
