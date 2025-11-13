defmodule AshPostgres.TestRepo.Migrations.AddCollatedPostsTable do
  @moduledoc """
  Migration to create collated_posts table for testing CollatedString type.

  Note: No COLLATE clauses in DDL - collation is applied at query level only.
  """
  use Ecto.Migration

  def up do
    create table(:collated_posts, primary_key: false) do
      add(:id, :uuid, primary_key: true, null: false)
      add(:title, :text, null: false)
      add(:content, :text)
      add(:tags, :text)
      add(:author, :text)

      timestamps()
    end
  end

  def down do
    drop(table(:collated_posts))
  end
end
