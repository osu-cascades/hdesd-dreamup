defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players

  def mount(_params, _session, socket) do
    socket = assign(socket, round_active: false)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    socket = assign(socket, player: player, game: Games.get_game!(String.to_integer(params["game_id"])))
    {:noreply, socket}
  end

  def handle_event("start-round", _, socket) do
    countdown()
    Games.broadcast(:start_round, socket.assigns.game.id)
    {:noreply, assign(socket, round_active: true)}
  end

  def countdown() do
    :timer.send_interval(2000, self(), :tick)
  end

  def handle_info(:tick, socket) do
    Games.decrease_time(socket.assigns.game)
    {:noreply, socket}
  end

  def handle_info({:start_round}, socket) do
    {:noreply, assign(socket, round_active: true)}
  end

  def handle_info({:update_game, event}, socket) do
    {_, game} = event
    {:noreply, assign(socket, game: game)}
  end

end
