defmodule HackerNews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HackerNewsWeb.Telemetry,
      HackerNews.Repo,
      {DNSCluster, query: Application.get_env(:hacker_news, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HackerNews.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HackerNews.Finch},
      # Start a worker by calling: HackerNews.Worker.start_link(arg)
      # {HackerNews.Worker, arg},
      # Start to serve requests, typically the last entry
      HackerNewsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HackerNews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HackerNewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
