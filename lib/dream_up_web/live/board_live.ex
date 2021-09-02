defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players

  def mount(_params, _session, socket) do
    socket = assign(socket, round_active: false, timer: nil)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    socket = assign(socket, player: player, game: Games.get_game!(String.to_integer(params["game_id"])))
    {:noreply, socket}
  end

  def handle_event("start-round", _, socket) do
    new_socket = countdown(socket)
    Games.broadcast(:start_round, socket.assigns.game.id)
    IO.inspect("start round event")
    {:noreply, new_socket}
  end

  def handle_event("add-time", _, socket) do
    Games.add_time(socket.assigns.game, socket.assigns.player.team_leader)
    {:noreply, socket}
  end

  def countdown(socket) do
    unless socket.assigns.timer do
      assign(socket, timer: :timer.send_interval(1000, self(), :tick))
    else
      socket
    end
  end

  def handle_info(:tick, socket) do
    Games.decrease_time(socket.assigns.game, socket.assigns.round_active)
    {:noreply, socket}
  end

  def handle_info({:start_round}, socket) do
    # change back to 5 minutes
    Games.update_game(socket.assigns.game, %{time_left: ~T[00:00:05]} )
    {:noreply, assign(socket, round_active: true)}
  end

  def handle_info({:update_game, event}, socket) do
    {_, game} = event
    {:noreply, assign(socket, game: game)}
  end

  def handle_info({:time_up}, socket) do
    # IO.puts("Time's up")
    # IO.inspect(socket.assigns.timer)
    # if socket.assigns.timer do
    #   {_, {_, timer}} = socket.assigns.timer
    #   Process.cancel_timer(timer)
    # end
    {:noreply, assign(socket, round_active: false)}
  end

end
