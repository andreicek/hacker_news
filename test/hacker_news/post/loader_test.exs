defmodule HackerNews.Post.LoaderTest do
  use HackerNews.DataCase

  alias HackerNews.{Post, Post.Loader}

  describe "get_all/0" do
    test "gets all posts" do
      for _ <- 0..4, do: post_fixture()

      assert posts = Loader.get_all()

      assert length(posts) == 5

      assert [
               %{
                 comments_count: 0,
                 post: %HackerNews.Post{} = _post_content
               }
               | _rest
             ] = posts
    end
  end

  describe "fetch_by_id/1" do
    test "returns a posts when given a correct id" do
      post = post_fixture()
      post_id = post.id

      assert {:ok,
              %Post{
                id: ^post_id,
                comments: []
              }} = Loader.fetch_by_id(post.id)
    end

    test "returns an error when post is not found" do
      id = Ecto.UUID.generate()
      _post = post_fixture()

      assert {:error, :not_found} = Loader.fetch_by_id(id)
    end
  end
end
