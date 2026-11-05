defmodule AshPostgres.Test.DeltaModeHelpers do
  @moduledoc false

  import ExUnit.CaptureIO
  alias AshPostgres.MigrationGenerator
  alias AshPostgres.MigrationGenerator.{Operation.Codec, Reducer}

  @spec generate(domain :: module(), options :: keyword()) :: String.t()
  def generate(domain, options) do
    {input, options} = Keyword.pop(options, :input, "")
    path = Keyword.fetch!(options, :migration_path)

    name =
      "migrate_resources_#{domain |> Module.split() |> List.last() |> Macro.underscore()}_#{Path.basename(path)}_#{length(migration_files(path))}"

    capture_io([input: input], fn ->
      MigrationGenerator.generate(domain, Keyword.put(options, :name, name))
    end)
  end

  @spec run_codegen(
          domain :: module(),
          snapshot_path :: String.t(),
          migration_path :: String.t(),
          extra :: keyword()
        ) :: String.t()
  def run_codegen(domain, snapshot_path, migration_path, extra \\ []) do
    generate(
      domain,
      Keyword.merge(
        [
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          tenant_migration_path: Path.join(Path.dirname(migration_path), "tenant_migrations"),
          quiet: true,
          format: false,
          snapshot_format: :delta
        ],
        extra
      )
    )
  end

  @spec delta_files(snapshot_path :: String.t(), table :: String.t()) :: [String.t()]
  def delta_files(snapshot_path, table),
    do: Path.wildcard("#{snapshot_path}/**/#{table}/*.json") |> Enum.sort()

  @spec read_delta(path :: String.t()) :: map()
  def read_delta(path), do: path |> File.read!() |> Codec.decode_delta()

  @spec migration_files(path :: String.t()) :: [String.t()]
  def migration_files(path) do
    Path.wildcard("#{path}/**/*_migrate_resources*.exs")
    |> Enum.reject(&String.contains?(&1, "extensions"))
    |> Enum.sort()
  end

  @spec ops_of_type(delta :: map(), module :: module()) :: [struct()]
  def ops_of_type(delta, module), do: Enum.filter(delta.operations, &(&1.__struct__ == module))

  @spec reduce_dir(snapshot_path :: String.t(), table :: String.t(), schema :: String.t() | nil) ::
          map()
  def reduce_dir(snapshot_path, table, schema \\ nil) do
    snapshot = %{
      table: table,
      schema: schema,
      repo: AshPostgres.TestRepo,
      multitenancy: %{strategy: nil, attribute: nil, global: nil}
    }

    Reducer.load_reduced_state(snapshot, %MigrationGenerator{
      snapshot_path: snapshot_path,
      dev: false,
      quiet: true
    })
  end

  @spec migration_body_only(path :: String.t()) :: String.t()
  def migration_body_only(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn line -> String.starts_with?(String.trim_leading(line), "defmodule ") end)
    |> Enum.join("\n")
    |> String.replace(~r/\s+$/, "")
    |> String.trim()
  end

  @spec resource_migration_content(path :: String.t()) :: [String.t()]
  def resource_migration_content(path),
    do: path |> migration_files() |> Enum.map(&migration_body_only/1)

  @spec compile_migrations(path :: String.t()) :: [{integer(), module()}]
  def compile_migrations(path), do: Enum.map(migration_files(path), &compile_migration/1)

  @spec compile_migration(file :: String.t()) :: {integer(), module()}
  def compile_migration(file) do
    {version, "_" <> _name} = file |> Path.basename() |> Path.rootname() |> Integer.parse()

    [{module, _binary}] =
      file
      |> Code.compile_file()
      |> Enum.filter(fn {mod, _} -> function_exported?(mod, :__migration__, 0) end)

    {version, module}
  end

  @spec run_migrations(migrations :: [{integer(), module()}], direction :: :up | :down) :: :ok
  def run_migrations(migrations, direction) do
    repo = AshPostgres.TestRepo
    %{rows: rows} = repo.query!("SELECT version FROM schema_migrations")
    already_run = Enum.map(rows, fn [version] -> version end)
    migrations = if direction == :down, do: Enum.reverse(migrations), else: migrations

    Enum.each(migrations, fn {version, module} ->
      if (direction == :up and version not in already_run) or
           (direction == :down and version in already_run) do
        Ecto.Migration.Runner.run(
          repo,
          repo.config(),
          version,
          module,
          :forward,
          direction,
          direction,
          all: true
        )

        case direction do
          :up -> Ecto.Migration.SchemaMigration.up(repo, repo.config(), version, [])
          :down -> Ecto.Migration.SchemaMigration.down(repo, repo.config(), version, [])
        end
      end
    end)
  end

  @spec table_exists?(table :: String.t()) :: boolean()
  def table_exists?(table) do
    %{rows: [[exists]]} =
      AshPostgres.TestRepo.query!(
        "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = $1)",
        [table]
      )

    exists
  end

  @spec column_exists?(table :: String.t(), column :: String.t()) :: boolean()
  def column_exists?(table, column) do
    %{rows: [[exists]]} =
      AshPostgres.TestRepo.query!(
        "SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = $1 AND column_name = $2)",
        [table, column]
      )

    exists
  end

  @spec capture_table_schema(table :: String.t()) :: [[term()]]
  def capture_table_schema(table) do
    %{rows: rows} =
      AshPostgres.TestRepo.query!(
        """
        SELECT column_name, data_type, is_nullable, column_default
        FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = $1
        ORDER BY column_name
        """,
        [table]
      )

    rows
  end
end
