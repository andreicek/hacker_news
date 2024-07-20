defmodule HackerNews.Post.Comment.Mutator do
  import Ecto.Changeset

  alias HackerNews.{Repo, Post.Comment}

  def create(params) do
    %Comment{}
    |> changeset(params)
    |> Repo.insert()
  end

  def changeset(%Comment{} = schema, params) do
    schema
    |> cast(params, ~w(post_id author content)a)
    |> validate_required(~w(post_id author content)a)
  end

  def apply(schema, params) do
    with %{valid?: true} = changeset <- changeset(schema, params) do
      {:ok, apply_changes(changeset), changeset}
    end
  end
end
