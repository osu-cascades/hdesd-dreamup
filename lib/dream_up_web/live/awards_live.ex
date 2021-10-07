defmodule DreamUpWeb.AwardsLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards

  def mount(_params, _session, socket) do
    socket = assign(socket, foo: nil)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    IO.inspect(params["game_id"])
    IO.inspect(params["player_id"])
    {:noreply, socket}
  end


end
