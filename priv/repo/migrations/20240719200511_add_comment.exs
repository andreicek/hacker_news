defmodule HackerNews.Repo.Migrations.AddComment do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :author, :string
      add :content, :string

      add :post_id, references(:posts, type: :uuid), null: false

      timestamps()
    end
  end
end
