defmodule HackerNews.Comment.UseCaseTest do
  use HackerNews.DataCase

  alias HackerNews.{PubSub, Post.Comment.UseCase}

  describe "create/1" do
    setup do
      post = post_fixture()
      :ok = PubSub.subscribe("post:#{post.id}")

      {:ok, post: post}
    end

    test "create a comment on a post and broadcasts a message", %{post: post} do
      params = %{
        "author" => "andrei",
        "content" => "cool post"
      }

      assert {:ok, comment} = UseCase.create(post.id, params)

      assert comment.post_id == post.id
      assert comment.author == params["author"]
      assert comment.content == params["content"]

      assert_receive {:new_comment, params}

      assert params.author == comment.author
      assert params.content == comment.content
    end

    test "does not broadcasts a message on error", %{post: post} do
      params = %{
        "author" => "andrei"
      }

      assert {:error, _changeset} = UseCase.create(post.id, params)

      refute_receive {:new_comment, _params}
    end
  end
end
