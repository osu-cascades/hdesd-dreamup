defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards

  @method_card_map %{1 => "Empathize", 2 => "Define", 3 => "Ideate", 4 => "Prototype", 5 => "Test", 6 => "Mindset"}

  def mount(_params, _session, socket) do
    socket = assign(socket, timer: nil, method: nil, current_method: nil, game: %{round_state: "GAME_START"})
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    socket = assign(socket, player: player, game: Games.get_game!(String.to_integer(params["game_id"])))
    {:noreply, socket}
  end

  def handle_event("start-round", _, socket) do
    random_number = :rand.uniform(6)
    Cards.get_random_card_from_method(@method_card_map[random_number])
    new_socket = countdown(socket)
    # change time_left back to 5 minutes
    Games.update_game(socket.assigns.game, %{time_left: ~T[00:00:10], round_state: "SPINNER"})
    {:noreply, assign(new_socket, %{current_method: @method_card_map[random_number]})}
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
    Games.decrease_time(socket.assigns.game)
    {:noreply, socket}
  end

  def handle_info({:update_game, event}, socket) do
    {_, game} = event
    {:noreply, assign(socket, game: game)}
  end

end
