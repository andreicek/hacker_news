defmodule HackerNewsWeb.Live.Helpers do
  def format_timestamp(timestamp), do: Calendar.strftime(timestamp, "%Y-%m-%d %H:%M")
  def format_date(timestamp), do: Calendar.strftime(timestamp, "%Y-%m-%d")
end
