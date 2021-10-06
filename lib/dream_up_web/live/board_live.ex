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
    all_method_cards = Enum.filter(Enum.map( game_values, fn {k, v} ->
      if String.slice(Atom.to_string(k), 0..6) === "method_" && v do
        Cards.get_card!(v)
      end
    end), & !is_nil(&1))
    method_cards = List.delete_at(all_method_cards, length(all_method_cards) - 1)

    if game.round_number === 0 do
      socket = assign(socket, player: player, game: game, method_card: nil)
      if player.game_admin do
        {:noreply, countdown(socket)}
      else
        {:noreply, socket}
      end
    else
      # TODO: Refactor to remove repitition
      if player.game_admin do
        case game.round_number do
          1 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_1_id), method_cards: method_cards))}
          2 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_2_id), method_cards: method_cards))}
          3 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_3_id), method_cards: method_cards))}
          4 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_4_id), method_cards: method_cards))}
          5 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_5_id), method_cards: method_cards))}
          6 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_6_id), method_cards: method_cards))}
          7 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_7_id), method_cards: method_cards))}
          8 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_8_id), method_cards: method_cards))}
          9 ->
            {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_9_id), method_cards: method_cards))}
        end
      else
        case game.round_number do
          1 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_1_id), method_cards: method_cards)}
          2 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_2_id), method_cards: method_cards)}
          3 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_3_id), method_cards: method_cards)}
          4 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_4_id), method_cards: method_cards)}
          5 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_5_id), method_cards: method_cards)}
          6 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_6_id), method_cards: method_cards)}
          7 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_7_id), method_cards: method_cards)}
          8 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_8_id), method_cards: method_cards)}
          9 ->
            {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(game.method_9_id), method_cards: method_cards)}
        end
      end
    end
  end

  def handle_event("skip-gameplay", _, socket) do
    Games.update_game(socket.assigns.game, %{round_state: "DISCUSSION", time_left: socket.assigns.method_card.discussion_time})
    {:noreply, socket}
  end

  def handle_event("skip-discussion", _, socket) do
    Games.broadcast(:round_over, socket.assigns.game.id)
    Cards.start_spinner_state(socket.assigns.game)
    {:noreply, socket}
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
    Games.decrease_time(socket.assigns.game, socket.assigns.method_card)
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

  def handle_info({:round_over}, socket) do
    {:noreply, update(socket, :method_cards, fn method_cards -> method_cards ++ [socket.assigns.method_card] end)}
  end

end
