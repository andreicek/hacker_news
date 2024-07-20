defmodule HackerNews.PubSub do
  alias Phoenix.PubSub

  def broadcast(topic, payload), do: PubSub.broadcast(__MODULE__, topic, payload)

  def subscribe(topic), do: PubSub.subscribe(__MODULE__, topic)
end
