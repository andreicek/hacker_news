defmodule HackerNews.Fixtures do
  alias HackerNews.Post

  @post_params %{title: "Example link", link: "https://example.org"}

  def post_fixture(params \\ %{}) do
    params = Map.merge(@post_params, params)

    {:ok, post} = Post.Mutator.create(params)

    post
  end
end
