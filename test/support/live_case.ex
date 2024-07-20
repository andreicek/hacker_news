defmodule HackerNewsWeb.LiveCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint HackerNewsWeb.Endpoint

      use HackerNewsWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import HackerNewsWeb.LiveCase
      import HackerNews.Fixtures
    end
  end

  setup tags do
    HackerNews.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
