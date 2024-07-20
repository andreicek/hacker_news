defmodule HackerNewsWeb.Live.Home.Index do
  use HackerNewsWeb, :live_view

  alias HackerNews.Post

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(_params, _url, socket) do
    posts = Post.Loader.get_all()

    socket = assign(socket, posts: posts)

    {:noreply, socket}
  end
end
