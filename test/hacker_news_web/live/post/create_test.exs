defmodule HackerNewsWeb.Live.Post.CreateTest do
  use HackerNewsWeb.LiveCase

  alias HackerNews.{Repo, Post}

  test "renders form", %{conn: conn} do
    assert {:ok, _view, html} =
             conn
             |> get("/post/new")
             |> live()

    assert html =~ "Create a new post"
  end

  test "saves a new post", %{conn: conn} do
    assert {:ok, view, _html} =
             conn
             |> get("/post/new")
             |> live()

    assert {:error, {:redirect, %{to: "/"}}} =
             view
             |> form(~s(form[data-test="post_form"]),
               post: %{
                 title: "Cool post",
                 link: "https://example.com"
               }
             )
             |> render_submit()

    assert %{
             title: "Cool post",
             link: "https://example.com"
           } = Repo.one(Post)
  end
end
