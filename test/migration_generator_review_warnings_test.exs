# SPDX-FileCopyrightText: 2019 ash_postgres contributors <https://github.com/ash-project/ash_postgres/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshPostgres.MigrationGeneratorReviewWarningsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  @moduletag :migration
  @moduletag :tmp_dir

  @baseline "Please always manually review the generated migrations for correctness."
  @commented_warning "migration steps commented out and in need of manual review"
  @destructive_warning "destructive operations"
  @warning_prefix "Warning:"

  defmodule Scenario1ReviewWarnAddPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_add_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario1Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario1ReviewWarnAddPostVersion1
      )
    end
  end

  defmodule Scenario2ReviewWarnColumnPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_column_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario2Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario2ReviewWarnColumnPostVersion1
      )
    end
  end

  defmodule Scenario2ReviewWarnColumnPostVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_column_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario2Domain2 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario2ReviewWarnColumnPostVersion2
      )
    end
  end

  defmodule Scenario3ReviewWarnKeepPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_keep_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario3ReviewWarnDropPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_drop_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario3Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario3ReviewWarnKeepPostVersion1
      )

      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario3ReviewWarnDropPostVersion1
      )
    end
  end

  defmodule Scenario3Domain2 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario3ReviewWarnKeepPostVersion1
      )
    end
  end

  defmodule Scenario4ReviewWarnRemoveColumnVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_remove_column"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
      attribute(:title, :string, public?: true)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario4Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario4ReviewWarnRemoveColumnVersion1
      )
    end
  end

  defmodule Scenario4ReviewWarnRemoveColumnVersion2 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_remove_column"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario4Domain2 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario4ReviewWarnRemoveColumnVersion2
      )
    end
  end

  defmodule Scenario5ReviewWarnQuietPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_quiet_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario5Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario5ReviewWarnQuietPostVersion1
      )
    end
  end

  defmodule Scenario6ReviewWarnCheckPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_check_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario6Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario6ReviewWarnCheckPostVersion1
      )
    end
  end

  defmodule Scenario7ReviewWarnNoShellPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_noshell_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario7Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario7ReviewWarnNoShellPostVersion1
      )
    end
  end

  defmodule Scenario8ReviewWarnDryRunPostVersion1 do
    use Ash.Resource, domain: nil, data_layer: AshPostgres.DataLayer

    postgres do
      table "review_warn_dry_run_posts"
      repo AshPostgres.TestRepo
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end

    attributes do
      uuid_primary_key(:id)
    end

    actions do
      defaults([:create, :read, :update, :destroy])
    end
  end

  defmodule Scenario8Domain1 do
    use Ash.Domain

    resources do
      resource(
        AshPostgres.MigrationGeneratorReviewWarningsTest.Scenario8ReviewWarnDryRunPostVersion1
      )
    end
  end

  setup %{tmp_dir: tmp_dir} do
    %{
      snapshot_path: Path.join(tmp_dir, "snapshots"),
      migration_path: Path.join(tmp_dir, "migrations")
    }
  end

  @tag story: "US-APMG-081"
  test "emits baseline reminder for additive migrations", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    output =
      capture_io("", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario1Domain1,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: false,
          format: false,
          auto_name: true,
          name: "review_warn_add"
        )
      end)

    assert output =~ @baseline
    refute output =~ @warning_prefix
  end

  @tag story: "US-APMG-082"
  test "emits commented safeguard escalation with dont_drop_columns", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario2Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "review_warn_setup_column"
      )
    end)

    output =
      capture_io("n\n", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario2Domain2,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: false,
          format: false,
          auto_name: true,
          name: "review_warn_comment_column",
          dont_drop_columns: true
        )
      end)

    latest =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    assert latest =~ "Attribute removal has been commented out"
    refute latest =~ ~r/^\s*remove "title"/m

    assert output =~ @baseline
    assert output =~ @commented_warning
    refute output =~ @destructive_warning
  end

  @tag story: "US-APMG-083"
  test "emits destructive escalation when dropping a table", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario3Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "review_warn_setup_drop"
      )
    end)

    output =
      capture_io("y\n", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario3Domain2,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: false,
          format: false,
          auto_name: true,
          name: "review_warn_drop"
        )
      end)

    latest =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    assert latest =~ "drop table(:review_warn_drop_posts)"
    assert output =~ @baseline
    assert output =~ @destructive_warning
    refute output =~ @commented_warning
  end

  @tag story: "US-APMG-084"
  test "emits destructive escalation when removing a column", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    capture_io("", fn ->
      AshPostgres.MigrationGenerator.generate(Scenario4Domain1,
        snapshot_path: snapshot_path,
        migration_path: migration_path,
        quiet: true,
        format: false,
        auto_name: true,
        name: "review_warn_setup_column"
      )
    end)

    output =
      capture_io("n\n", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario4Domain2,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: false,
          format: false,
          auto_name: true,
          name: "review_warn_remove_column"
        )
      end)

    latest =
      Path.wildcard("#{migration_path}/**/*.exs")
      |> Enum.reject(&String.contains?(&1, "extensions"))
      |> Enum.sort()
      |> List.last()
      |> File.read!()

    assert latest =~ ~r/^\s*remove :title/m
    assert output =~ @baseline
    assert output =~ @destructive_warning
    refute output =~ @commented_warning
  end

  @tag story: "US-APMG-085"
  test "does not emit review warnings when quiet is true", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    output =
      capture_io("", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario5Domain1,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: true,
          format: false,
          auto_name: true,
          name: "review_warn_quiet"
        )
      end)

    refute output =~ @baseline
    refute output =~ @warning_prefix
  end

  @tag story: "US-APMG-086"
  test "does not emit review warnings when check is true", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    output =
      capture_io(fn ->
        assert_raise Ash.Error.Framework.PendingCodegen, fn ->
          AshPostgres.MigrationGenerator.generate(Scenario6Domain1,
            snapshot_path: snapshot_path,
            migration_path: migration_path,
            check: true,
            quiet: false,
            format: false,
            auto_name: true
          )
        end
      end)

    assert Path.wildcard("#{snapshot_path}/test_repo/review_warn_check_posts/*.json") == []

    assert Path.wildcard("#{migration_path}/**/*_migrate_resources*.exs") == []

    assert output == ""
  end

  @tag story: "US-APMG-087"
  test "does not emit review warnings when no_shell? is true", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    output =
      capture_io("", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario7Domain1,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          quiet: false,
          no_shell?: true,
          format: false,
          auto_name: true,
          name: "review_warn_noshell"
        )
      end)

    refute output =~ @baseline
    refute output =~ @warning_prefix
  end

  @tag story: "US-APMG-088"
  test "emits review warnings on dry_run", %{
    snapshot_path: snapshot_path,
    migration_path: migration_path
  } do
    # Given real immutable resource versions and case-owned persisted generation state.
    # When the real generator runs with the declared review-warning mode.
    # Then the original migration safety and captured-output assertions remain intact.

    output =
      capture_io("", fn ->
        AshPostgres.MigrationGenerator.generate(Scenario8Domain1,
          snapshot_path: snapshot_path,
          migration_path: migration_path,
          dry_run: true,
          quiet: false,
          format: false,
          auto_name: true
        )
      end)

    assert output =~ @baseline
    refute output =~ @warning_prefix
  end
end
