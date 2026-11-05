# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorTimestamptzTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  defmodule TimestamptzRepo do
    use AshPostgres.Repo, otp_app: :ash_postgres

    @impl AshPostgres.Repo
    @spec installed_extensions() :: [String.t()]
    def installed_extensions, do: ["ash-functions"]

    @impl AshPostgres.Repo
    @spec use_timestamptz?() :: boolean()
    def use_timestamptz?, do: true

    @impl AshPostgres.Repo
    @spec min_pg_version() :: Version.t()
    def min_pg_version, do: %Version{major: 16, minor: 0, patch: 0}
  end

  defmodule Post do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "timestamptz_posts"
      repo AshPostgres.MigrationGeneratorTimestamptzTest.TimestamptzRepo
      migration_types explicit_type: :utc_datetime
    end

    actions do
      create :create do
        accept([:starts_at])
      end

      read :read do
        primary?(true)
      end
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:starts_at, :datetime, public?: true)
      attribute(:explicit_type, :datetime, public?: true)
    end
  end

  defmodule Domain do
    use Ash.Domain

    resources do
      resource(AshPostgres.MigrationGeneratorTimestamptzTest.Post)
    end
  end

  setup %{tmp_dir: tmp_dir} do
    config = Keyword.put(AshPostgres.TestRepo.config(), :name, TimestamptzRepo)
    start_supervised!({TimestamptzRepo, config})
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TimestamptzRepo)

    Ecto.Adapters.SQL.query!(TimestamptzRepo, """
    CREATE TABLE timestamptz_posts (
      id uuid PRIMARY KEY,
      starts_at timestamptz,
      explicit_type timestamp without time zone
    )
    """)

    assert AshPostgres.SqlImplementation.storage_type(Post, :starts_at) == nil
    migration_path = Path.join(tmp_dir, "migrations")

    capture_io(fn ->
      AshPostgres.MigrationGenerator.generate(Domain,
        snapshot_path: Path.join(tmp_dir, "snapshots"),
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true
      )
    end)

    %{migration_path: migration_path}
  end

  @tag story: "US-APMG-003"
  test "uses timestamptz for :datetime when enabled", %{migration_path: migration_path} do
    # Given a repository that explicitly enables timestamptz and a generated resource migration.
    files =
      Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))

    # When the actual generated migration is read.
    assert [file] = files
    file_contents = File.read!(file)

    # Then the default changes while an explicit migration type remains honored.
    assert file_contents =~ ~S[add :starts_at, :timestamptz]
    assert file_contents =~ ~S[add :explicit_type, :utc_datetime]
  end

  @tag story: "US-APMG-004"
  test "uses timestamptz Ecto type when enabled" do
    # Given the real compiled resource using the enabled repository.
    # When Ecto exposes its starts_at type.
    # Then it retains the native timestamptz precision and casting contract.
    assert Post.__schema__(:type, :starts_at) ==
             {:parameterized,
              {AshPostgres.Timestamptz.EctoType,
               [precision: :second, cast_dates_as: :start_of_day, timezone: :utc]}}
  end

  @tag story: "US-APMG-005"
  test "preserves datetime across database timezone changes" do
    # Given a timestamp persisted by the real resource create action.
    datetime = ~U[2026-01-15 12:00:00Z]

    post =
      Post
      |> Ash.Changeset.for_create(:create, %{starts_at: datetime}, domain: Domain)
      |> Ash.create!()

    # When this transaction changes its database timezone and reads the persisted record.
    {:ok, _result} =
      Ecto.Adapters.SQL.query(TimestamptzRepo, "SET LOCAL timezone = 'America/Los_Angeles'")

    loaded = Ash.get!(Post, post.id, domain: Domain)

    # Then the instant remains identical.
    assert DateTime.compare(loaded.starts_at, datetime) == :eq
  end
end
