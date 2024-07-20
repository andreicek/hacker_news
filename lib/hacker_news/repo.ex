defmodule HackerNews.Repo do
  use Ecto.Repo,
    otp_app: :hacker_news,
    adapter: Ecto.Adapters.Postgres

  def fetch(query, opts \\ []) do
    case one(query, opts) do
      nil -> {:error, :not_found}
      value -> {:ok, value}
    end
  end
end
