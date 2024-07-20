defmodule HackerNews.Post.MutatorTest do
  use HackerNews.DataCase

  alias HackerNews.{Post, Post.Mutator}

  describe "create/1" do
    test "creates a post when given valid params" do
      params = %{
        "title" => "FOSDEM '24 - IMPELENTING UDP PROTOCOLS IN ELIXIR",
        "link" => "https://0x7f.dev/posts/fosdem-24---impelenting-udp-protocols-in-elixir/"
      }

      assert {:ok, %Post{} = post} = Mutator.create(params)

      assert post.title == params["title"]
      assert post.link == params["link"]
    end

    test "returns error when title is missing" do
      params = %{
        "link" => "https://0x7f.dev/posts/fosdem-24---impelenting-udp-protocols-in-elixir/"
      }

      assert {:error,
              %{
                errors: [{:title, {"can't be blank", [validation: :required]}}]
              }} = Mutator.create(params)
    end

    test "returns error when link is missing" do
      params = %{
        "title" => "FOSDEM '24 - IMPELENTING UDP PROTOCOLS IN ELIXIR"
      }

      assert {:error,
              %{
                errors: [{:link, {"can't be blank", [validation: :required]}}]
              }} = Mutator.create(params)
    end
  end

  describe "changeset/2" do
    test "returns a changeset for an empty params" do
      assert %Ecto.Changeset{} = Mutator.changeset(%Post{}, %{})
    end

    test "returns a changeset for full params" do
      params = %{
        "title" => "A blog post",
        "link" => "https://example.com"
      }

      assert %Ecto.Changeset{} = Mutator.changeset(%Post{}, params)
    end
  end

  describe "apply/2" do
    test "applies changes to a schema and returns :ok for a valid schema" do
      schema = %Post{
        title: "A blog post"
      }

      params = %{"link" => "https://example.com"}

      assert {:ok, post, %Ecto.Changeset{}} = Mutator.apply(schema, params)

      assert post.title == schema.title
      assert post.link == params["link"]
    end

    test "applies changes to a schema and returns changeset for invalid schema" do
      schema = %Post{}

      params = %{"link" => "https://example.com"}

      assert %Ecto.Changeset{
               changes: %{link: "https://example.com"},
               errors: [title: {"can't be blank", [validation: :required]}]
             } = Mutator.apply(schema, params)
    end
  end
end
