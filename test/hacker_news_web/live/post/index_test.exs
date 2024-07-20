defmodule HackerNewsWeb.Live.Post.IndexTest do
  use HackerNewsWeb.LiveCase

  alias HackerNews.{Repo, Post.Comment}

  test "renders post", %{conn: conn} do
    post = post_fixture()

    assert {:ok, _view, html} =
             conn
             |> get("/post/#{post.id}")
             |> live()

    assert html =~ post.title
    assert html =~ post.link
    assert html =~ "No comments yet, leave the first one..."
  end

  test "saves a new comment", %{conn: conn} do
    %{id: post_id} = post_fixture()

    assert {:ok, view, _html} =
             conn
             |> get("/post/#{post_id}")
             |> live()

    assert view
           |> form(~s(form[data-test="comment_form"]),
             comment: %{
               author: "User #1",
               content: "Cool post!"
             }
           )
           |> render_submit()

    assert %{
             post_id: ^post_id,
             author: "User #1",
             content: "Cool post!"
           } = Repo.one(Comment)
  end

  test "when a new comment is inserted it renders it", %{conn: conn} do
    %{id: post_id} = post_fixture()

    assert {:ok, view, _html} =
             conn
             |> get("/post/#{post_id}")
             |> live()

    Comment.UseCase.create(post_id, %{"author" => "User #1", "content" => "Cool post!"})

    assert view = render(view)
    assert view =~ "User #1"
    assert view =~ "Cool post!"
  end
end
