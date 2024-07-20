defmodule HackerNews.Repo.Migrations.AddPost do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :link, :string

      timestamps()
    end
  end
end
