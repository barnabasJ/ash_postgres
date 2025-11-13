# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.CollatedString do
  @constraints [
    collation: [
      type: :string,
      required: true,
      doc: """
      The PostgreSQL collation to use for this column at query time.

      Common collations:
      - `"C"` - Deterministic byte-order collation (fastest, enables LIKE/ILIKE)
      - `"POSIX"` - POSIX locale collation
      - `"en_US.utf8"` - US English locale-aware collation
      - `"default"` - Database default collation

      To see available collations, query: `SELECT collname FROM pg_collation`
      """
    ],
    allow_empty?: [
      type: :boolean,
      default: true
    ],
    trim?: [
      type: :boolean,
      default: false
    ]
  ]

  @moduledoc """
  A PostgreSQL-specific string type that applies collation at query level.

  ## Stub Implementation
  This is a minimal stub to allow test infrastructure to compile.
  Full implementation coming in Phase 1.

  ## Constraints

  #{Spark.Options.docs(@constraints)}
  """

  use Ash.Type
  use AshPostgres.Type

  @impl Ash.Type
  def storage_type(_constraints), do: :text

  @impl Ash.Type
  def constraints, do: @constraints

  @impl Ash.Type
  def cast_input(value, constraints) do
    Ash.Type.String.cast_input(value, constraints)
  end

  @impl Ash.Type
  def cast_stored(value, constraints) do
    Ash.Type.String.cast_stored(value, constraints)
  end

  @impl Ash.Type
  def dump_to_native(value, constraints) do
    Ash.Type.String.dump_to_native(value, constraints)
  end
end
