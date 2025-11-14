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

  This type wraps string columns with PostgreSQL `COLLATE` clauses in queries,
  enabling control over sort order and string comparison behavior without
  requiring collation specification in the database schema (DDL).

  ## Use Cases

  ### Django 4.2+ Compatibility

  Django 4.2+ uses nondeterministic collations (e.g., `en-US-u-ks-level2`) for
  case-insensitive fields. However, PostgreSQL < 18 does not support pattern
  matching (LIKE/ILIKE) with nondeterministic collations.

  This type allows you to override the column collation at query time with a
  deterministic collation like `"C"` or `"POSIX"` to enable pattern matching.

  ### Locale-Specific Sorting

  Different languages have different sorting rules. This type allows you to
  specify locale-aware collations (e.g., `"de_DE"` for German, `"en_US.utf8"`
  for US English) for proper alphabetical ordering.

  ## Basic Usage

      defmodule MyApp.User do
        use Ash.Resource,
          data_layer: AshPostgres.DataLayer

        attributes do
          # Use deterministic collation for case-insensitive searches with LIKE/ILIKE
          attribute :username, AshPostgres.CollatedString do
            constraints collation: "C"
            allow_nil? false
          end

          # Use locale-aware collation for proper sorting
          attribute :display_name, AshPostgres.CollatedString do
            constraints collation: "en_US.utf8"
            allow_nil? true
          end
        end
      end

      # Queries will automatically include COLLATE clauses:
      # SELECT * FROM users WHERE (username) COLLATE "C" ILIKE '%john%'
      User
      |> Ash.Query.filter(contains(username, "john"))
      |> Ash.read!()

  ## Available Collations

  To see all available collations in your PostgreSQL database:

      SELECT collname FROM pg_collation ORDER BY collname;

  Common collations:
  - `"C"` - Deterministic byte-order collation (fastest, supports LIKE/ILIKE)
  - `"POSIX"` - POSIX locale collation (deterministic)
  - `"en_US.utf8"` - US English locale-aware collation
  - `"de_DE"` - German locale-aware collation
  - `"fr_FR"` - French locale-aware collation
  - `"default"` - Database default collation

  ## PostgreSQL Version Compatibility

  ### PostgreSQL < 18

  Pattern matching operators (LIKE, ILIKE, ~, ~*) **do not work** with
  nondeterministic collations. You will get errors like:

      ERROR: nondeterministic collations are not supported for LIKE

  **Solution**: Use deterministic collations like `"C"` or `"POSIX"` at query
  time to enable pattern matching on columns with nondeterministic collations.

  ### PostgreSQL 18+

  Full support for pattern matching with nondeterministic collations.
  See: https://www.depesz.com/2025/01/10/waiting-for-postgresql-18-support-like-with-nondeterministic-collations/

  ## Security

  This type uses `Ecto.Query.API.literal/1` to properly escape collation names
  as PostgreSQL identifiers, preventing SQL injection attacks. Each unique
  collation name generates a separate prepared statement, which is an acceptable
  trade-off for security.

  ## Storage

  This type stores values as standard PostgreSQL `text` columns. The collation
  is applied **only in queries**, not in the DDL. This allows you to work with
  existing database tables (e.g., created by Django) without schema changes.

  ## References

  - GitHub Issue: [#650](https://github.com/ash-project/ash_postgres/issues/650)
  - PostgreSQL Collation Docs: https://www.postgresql.org/docs/current/collation.html
  - Django Forum Discussion: https://forum.djangoproject.com/t/icontains-lookup-when-using-nondeterministic-collations-in-postgres-fails/25696

  ## Constraints

  #{Spark.Options.docs(@constraints)}
  """

  use Ash.Type
  use AshPostgres.Type

  @doc """
  Returns the PostgreSQL storage type for this Ash type.

  Always returns `:text` because collation is applied at query time, not in DDL.
  This allows working with existing database columns without schema migrations.
  """
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

  @doc """
  Wraps column references with PostgreSQL COLLATE clauses.

  This callback is automatically invoked by AshPostgres when building SQL queries
  for filtering, sorting, and other operations involving this type.

  ## Examples

      # For a field with `constraints: [collation: "C"]`
      # Generates: (column_name) COLLATE "C"

      # In a WHERE clause:
      # WHERE (username) COLLATE "C" ILIKE '%search%'

      # In an ORDER BY clause:
      # ORDER BY (display_name) COLLATE "en_US.utf8" ASC

  ## Parameters

  - `_type` - The type module (this module, passed by AshPostgres)
  - `constraints` - The constraints for this type instance (must include `:collation`)
  - `expr` - The Ecto query dynamic expression for the column reference

  ## Returns

  - `{:ok, dynamic}` - A dynamic Ecto query expression with COLLATE wrapper
  - `{:error, message}` - If collation constraint is missing or invalid

  ## Security

  Uses `Ecto.Query.API.literal/1` to safely escape the collation name as a
  PostgreSQL identifier, preventing SQL injection attacks.
  """
  @impl AshPostgres.Type
  def postgres_reference_expr(_type, constraints, expr) do
    require Ecto.Query

    collation = Keyword.get(constraints, :collation)

    cond do
      is_nil(collation) ->
        {:error, "CollatedString requires a :collation constraint"}

      not is_binary(collation) ->
        {:error,
         "CollatedString :collation constraint must be a string, got: #{inspect(collation)}"}

      true ->
        # Use literal/1 for SQL injection prevention by properly escaping the collation name as a PostgreSQL identifier
        # Parentheses around expr are critical for correct precedence in complex expressions
        require Ecto.Query
        import Ecto.Query, only: [dynamic: 1]

        {:ok, dynamic(fragment("(?) COLLATE ?", ^expr, literal(^collation)))}
    end
  end
end
