defmodule HackerNews.Post.Comment.UseCase do
  alias HackerNews.{PubSub, Post.Comment, Post.Comment.Mutator}

  def new, do: Mutator.changeset(%Comment{}, %{})

  def create(post_id, params) do
    params = Map.put(params, "post_id", post_id)

    with {:ok, comment} <- Mutator.create(params),
         :ok <- PubSub.broadcast("post:#{post_id}", {:new_comment, comment}),
         do: {:ok, comment}
  end
end
