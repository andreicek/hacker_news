defmodule HackerNewsWeb.Live.Post.Index do
  use HackerNewsWeb, :live_view

  alias HackerNews.{PubSub, Post, Post.Comment}

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(%{"id" => post_id} = _params, _url, socket) do
    socket =
      with {:ok, post} <- Post.Loader.fetch_by_id(post_id) do
        PubSub.subscribe("post:#{post.id}")

        assign(socket, %{
          post: post,
          comments: post.comments,
          new_comment: %Comment{post_id: post.id},
          form: Comment.UseCase.new()
        })
      end

    {:noreply, socket}
  end

  def handle_info({:new_comment, comment}, socket) do
    comments = socket.assigns.comments

    socket = assign(socket, comments: [comment | comments])

    {:noreply, socket}
  end

  def handle_event("validate", %{"comment" => comment}, socket) do
    new_comment = socket.assigns.new_comment

    socket =
      with {:ok, comment, changeset} <- Comment.Mutator.apply(new_comment, comment) do
        assign(socket, %{
          new_comment: comment,
          form: changeset
        })
      else
        error ->
          assign(socket, form: error)
      end

    {:noreply, socket}
  end

  def handle_event("post", %{"comment" => comment}, socket) do
    post = socket.assigns.post

    socket =
      with {:ok, %Comment{}} <- Comment.UseCase.create(post.id, comment) do
        assign(socket, %{
          new_comment: %Comment{post_id: post.id},
          form: Comment.UseCase.new()
        })
      else
        {:error, changeset} ->
          assign(socket, form: changeset)
      end

    {:noreply, socket}
  end
end
