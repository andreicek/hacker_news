defmodule HackerNews.Post do
  use HackerNews.Schema

  alias HackerNews.Post.Comment

  schema "posts" do
    field :title, :string
    field :link, :string

    has_many :comments, Comment

    timestamps()
  end
end
