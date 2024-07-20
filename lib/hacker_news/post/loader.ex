defmodule HackerNews.Post.Loader do
  import Ecto.Query
  alias HackerNews.{Repo, Post, Post.Comment}

  def get_all do
    from(p in Post,
      left_join: c in assoc(p, :comments),
      order_by: {:desc, :inserted_at},
      distinct: true,
      group_by: p.id,
      select: %{
        post: p,
        comments_count: count(c.id)
      }
    )
    |> Repo.all()
  end

  def fetch_by_id(post_id) do
    comments_query = from(c in Comment, order_by: {:desc, :inserted_at})

    from(
      p in Post,
      where: p.id == ^post_id,
      preload: [comments: ^comments_query]
    )
    |> Repo.fetch()
  end
end
