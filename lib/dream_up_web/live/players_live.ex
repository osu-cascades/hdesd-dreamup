defmodule DreamUpWeb.PlayersLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Players
  alias DreamUp.Players.Player

  def mount(_params, _session, socket) do
    players = Players.list_players()

    socket = assign(socket, players: players)
    {:ok, socket}
  end

end
