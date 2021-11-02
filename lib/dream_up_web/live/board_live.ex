defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards

  alias DreamUp.Redirector

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

    {status, route} = Redirector.validate_game_phase(game, player.id, "BOARD", socket)
    if status !== :ok do
      {:noreply, redirect(socket, to: route)}
    else
      if game.round_number === 0 do
        socket = assign(socket, player: player, game: game, method_card: nil)
        if player.game_admin do
          {:noreply, countdown(socket)}
        else
          {:noreply, socket}
        end
      else
        if player.game_admin do
          {:noreply, countdown(assign(socket, player: player, game: game, method_card: Cards.get_card!(Enum.at(Games.get_method_card_list(game), game.round_number - 1)), method_cards: method_cards))}
        else
          {:noreply, assign(socket, player: player, game: game, method_card: Cards.get_card!(Enum.at(Games.get_method_card_list(game), game.round_number - 1)), method_cards: method_cards)}
        end
      end
    end
  end

  def handle_event("change-to-round-9", _, socket) do
    game = Map.delete(socket.assigns.game, :round_number)
    |> Map.delete(:method_7_id)
    |> Map.put(:round_number, 8)
    |> Map.put(:method_7_id, socket.assigns.method_card.id)
    Games.broadcast(:round_over, game.id)
    Cards.start_spinner_state(game)
    {:noreply, socket}
  end

  def handle_event("skip-gameplay", _, socket) do
    Games.update_game(socket.assigns.game, %{round_state: "DISCUSSION", time_left: socket.assigns.method_card.discussion_time})
    {:noreply, socket}
  end

  def handle_event("skip-discussion", _, socket) do
    if socket.assigns.game.round_number === 9 do
      Games.change_game_phase(socket.assigns.game.id, "AWARD")
      Games.broadcast(:finish_game, socket.assigns.game.id)
    else
      Games.broadcast(:round_over, socket.assigns.game.id)
      Cards.start_spinner_state(socket.assigns.game)
    end
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

  def handle_info({:finish_game}, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.AwardsLive, %{
      game_id: socket.assigns.game.id,
      player_id: socket.assigns.player.id
    }))}
  end

end
