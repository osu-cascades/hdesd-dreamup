defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players

  def mount(_params, _session, socket) do
    socket = assign(socket, round_active: false, time_left: Time.new(0, 5, 0, 0))
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    socket = assign(socket, game_id: String.to_integer(params["game_id"]), player: player)
    {:noreply, socket}
  end

  def handle_event("start-round", _, socket) do
    Games.broadcast(:start_round, socket.assigns.game_id)
    {:noreply, assign(socket, round_active: true)}
  end

  def handle_info({:start_round}, socket) do
    {:noreply, assign(socket, round_active: true)}
  end



end
