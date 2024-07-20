defmodule HackerNews.Post.Comment do
  use HackerNews.Schema

  alias HackerNews.Post

  schema "comments" do
    field :author, :string
    field :content, :string

    belongs_to :post, Post

    timestamps()
  end
end
