defmodule HackerNews.Post.Mutator do
  import Ecto.Changeset

  alias HackerNews.{Repo, Post}

  def create(params) do
    %Post{}
    |> changeset(params)
    |> Repo.insert()
  end

  def changeset(%Post{} = schema, params) do
    schema
    |> cast(params, ~w(title link)a)
    |> validate_required(~w(title link)a)
  end

  def apply(schema, params) do
    with %{valid?: true} = changeset <- changeset(schema, params) do
      {:ok, apply_changes(changeset), changeset}
    end
  end
end
