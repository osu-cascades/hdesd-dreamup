defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards

  @method_card_map %{1 => "Empathize", 2 => "Define", 3 => "Ideate", 4 => "Prototype", 5 => "Test", 6 => "Mindset"}

  def mount(_params, _session, socket) do
    socket = assign(socket, timer: nil, method: nil, method_card: nil, game: %{round_state: "GAME_START"})
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    game = Games.get_game!(String.to_integer(params["game_id"]))
    if game.round_number === 0 do
      socket = assign(socket, player: player, game: game, method_card: nil )
      {:noreply, socket}
    else
      method_card_id = game["method_" <> Integer.to_string(game.round_number) <> "_id"]
      socket = assign(socket, player: player, game: game, method_card: Cards.get_card!(method_card_id) )
      {:noreply, socket}
    end
  end

  def handle_event("start-round", _, socket) do
    set_method_card(socket)
    {:noreply, countdown(socket)}
  end

  def handle_event("pivot", _, socket) do
    set_method_card(socket, socket.assigns.player.team)
    {:noreply, socket}
  end

  def handle_event("add-time", _, socket) do
    Games.add_time(socket.assigns.game, socket.assigns.player.team_leader)
    {:noreply, socket}
  end

  def set_method_card(socket, pivot_to_remove \\ nil) do
    # TODO - Document better
    random_number = :rand.uniform(6)
    Cards.get_random_card_from_method(@method_card_map[random_number], socket.assigns.game)
    case pivot_to_remove do
      "red" ->
        Games.update_game(socket.assigns.game, %{time_left: ~T[00:00:10], round_state: "SPINNER", red_pivot_token: false})
      "blue" ->
        Games.update_game(socket.assigns.game, %{time_left: ~T[00:00:10], round_state: "SPINNER", blue_pivot_token: false})
      nil ->
        Games.update_game(socket.assigns.game, %{time_left: ~T[00:00:10], round_state: "SPINNER", round_number: socket.assigns.game.round_number + 1})
    end
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

  def handle_info({:update_game, data}, socket) do
    {_, game} = data
    {:noreply, assign(socket, game: game)}
  end

  def handle_info({:select_card, data}, socket) do
    {_, card} = data
    {:noreply, assign(socket, method_card: card)}
  end

end
