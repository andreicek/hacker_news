defmodule HackerNews.Post.UseCase do
  alias HackerNews.{Post, Post.Mutator}

  def new, do: Mutator.changeset(%Post{}, %{})
end
