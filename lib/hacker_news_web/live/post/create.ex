defmodule HackerNewsWeb.Live.Post.Create do
  use HackerNewsWeb, :live_view

  alias HackerNews.Post

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(_params, _url, socket) do
    socket =
      assign(socket, %{
        post: %Post{},
        form: Post.UseCase.new()
      })

    {:noreply, socket}
  end

  def handle_event("validate", %{"post" => post}, socket) do
    new_post = socket.assigns.post

    socket =
      with {:ok, post, changeset} <- Post.Mutator.apply(new_post, post) do
        assign(socket, %{
          post: post,
          form: changeset
        })
      else
        error ->
          assign(socket, form: error)
      end

    {:noreply, socket}
  end

  def handle_event("create", %{"post" => post}, socket) do
    socket =
      with {:ok, %Post{}} <- Post.Mutator.create(post) do
        socket
        |> put_flash(:info, "Post created!")
        |> redirect(to: ~p"/")
      else
        {:error, changeset} ->
          assign(socket, form: changeset)
      end

    {:noreply, socket}
  end
end
