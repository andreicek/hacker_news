defmodule HackerNews.Comment.MutatorTest do
  use HackerNews.DataCase

  alias HackerNews.{Post.Comment, Post.Comment.Mutator}

  describe "create/1" do
    test "create a comment on a post" do
      post = post_fixture()

      params = %{
        "post_id" => post.id,
        "author" => "andrei",
        "content" => "cool post"
      }

      assert {:ok, comment} = Mutator.create(params)

      assert comment.post_id == post.id
      assert comment.author == params["author"]
      assert comment.content == params["content"]
    end

    test "returns an error when post_id is missing" do
      params = %{
        "author" => "andrei",
        "content" => "cool post"
      }

      assert {:error,
              %{
                errors: [
                  {:post_id, {"can't be blank", [validation: :required]}}
                ]
              }} = Mutator.create(params)
    end

    test "returns an error when author is missing" do
      post = post_fixture()

      params = %{
        "post_id" => post.id,
        "content" => "cool post"
      }

      assert {:error,
              %{
                errors: [
                  {:author, {"can't be blank", [validation: :required]}}
                ]
              }} = Mutator.create(params)
    end

    test "returns an error when content is missing" do
      post = post_fixture()

      params = %{
        "post_id" => post.id,
        "author" => "andrei"
      }

      assert {:error,
              %{
                errors: [
                  {:content, {"can't be blank", [validation: :required]}}
                ]
              }} = Mutator.create(params)
    end
  end

  describe "changeset/2" do
    test "returns a changeset for an empty params" do
      assert %Ecto.Changeset{} = Mutator.changeset(%Comment{}, %{})
    end

    test "returns a changeset for full params" do
      params = %{
        "post_id" => Ecto.UUID.generate(),
        "author" => "User #1",
        "content" => "Comment."
      }

      assert %Ecto.Changeset{} = Mutator.changeset(%Comment{}, params)
    end
  end

  describe "apply/2" do
    test "applies changes to a schema and returns :ok for a valid schema" do
      schema = %Comment{
        post_id: Ecto.UUID.generate(),
        author: "User #1"
      }

      params = %{"content" => "Comment."}

      assert {:ok, comment, %Ecto.Changeset{}} = Mutator.apply(schema, params)

      assert comment.author == schema.author
      assert comment.content == params["content"]
    end

    test "applies changes to a schema and returns changeset for invalid schema" do
      schema = %Comment{
        post_id: Ecto.UUID.generate()
      }

      params = %{"content" => "Comment."}

      assert %Ecto.Changeset{
               changes: %{content: "Comment."},
               errors: [author: {"can't be blank", [validation: :required]}]
             } = Mutator.apply(schema, params)
    end
  end
end
