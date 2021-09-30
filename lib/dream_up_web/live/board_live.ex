defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards

  def mount(_params, _session, socket) do
    socket = assign(socket, timer: nil, method: nil, method_card: nil, method_cards: [], game: %{round_state: "GAME_START"})
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    game = Games.get_game!(String.to_integer(params["game_id"]))
    game_values = Map.to_list(game)
    Enum.each( game_values, fn {k, v} ->
      if String.slice(Atom.to_string(k), 0..6) === "method_" do
        # TODO: lookup v and then append result to list of method cards
      end
    end)
    if game.round_number === 0 do
      socket = assign(socket, player: player, game: game, method_card: nil )
      {:noreply, socket}
    else
      # method_card_id = game["method_" <> Integer.to_string(game.round_number) <> "_id"]
      # IO.inspect(Cards.get_card!(game.method_1_id))
      case game.round_number do
        1 ->
          # IO.inspect(Cards.get_card!(game.method_1_id))
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_1_id))}
        2 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_2_id))}
        3 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_3_id))}
        4 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_4_id))}
        5 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_5_id))}
        6 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_6_id))}
        7 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_7_id))}
        8 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_8_id))}
        9 ->
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_9_id))}
      end
    end
  end

  def handle_event("start-round", _, socket) do
    Cards.start_spinner_state(socket.assigns.game)
    {:noreply, countdown(socket)}
  end

  def handle_event("pivot", _, socket) do
    Cards.start_spinner_state(socket.assigns.game, socket.assigns.player.team, socket.assigns.method_card)
    {:noreply, socket}
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

  def handle_info({:update_game, data}, socket) do
    {_, game} = data
    {:noreply, assign(socket, game: game)}
  end

  def handle_info({:select_card, data}, socket) do
    {_, card} = data
    {:noreply, assign(socket, method_card: card)}
  end

end
