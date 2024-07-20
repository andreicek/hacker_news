defmodule HackerNewsWeb.Live.Home.IndexTest do
  use HackerNewsWeb.LiveCase

  test "renders posts", %{conn: conn} do
    post = post_fixture()

    assert {:ok, _view, html} =
             conn
             |> get("/")
             |> live()

    assert html =~ post.title
    assert html =~ post.link
    assert html =~ "comments (0)"
  end

  test "link to comment navigates to the appropriate page", %{conn: conn} do
    post = post_fixture()

    assert {:ok, view, _html} =
             conn
             |> get("/")
             |> live()

    assert {
             :error,
             {
               :live_redirect,
               %{kind: :push, to: "/post/#{post.id}"}
             }
           } ==
             view
             |> element(~s(a[data-test="comment_link"]))
             |> render_click()
  end
end
