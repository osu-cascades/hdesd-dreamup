defmodule DreamUpWeb.SetupLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Cards
  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Redirector


  def mount(_params, _session, socket) do
    cards = Cards.list_cards()
    socket = assign(socket, cards: cards, blue_challenge_id: nil, red_challenge_id: nil)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    socket = assign(socket, game_id: params["game_id"], player: player,
      is_single_team_game: length(
        Players.list_players_in_team(
          "red", params["game_id"]
        )
      ) === 0 || length(
        Players.list_players_in_team(
          "blue", params["game_id"]
        )
      ) === 0
    )
    game = Games.get_game!(params["game_id"])
    {status, route} = Redirector.validate_game_phase(game, player.id, "SETUP", socket)
    if status !== :ok do
      {:noreply, redirect(socket, to: route)}
    else
      {:noreply, Players.push_header_event(socket, player)}
    end
  end

  def handle_event("challenge-click", %{"card-id" => card_id}, socket) do
    Games.select_challenge(socket.assigns.game_id, String.to_integer(card_id), socket.assigns.player.team, socket.assigns.is_single_team_game)
    {:noreply, socket}
  end

  def handle_event("finish-setup", _, socket) do
    Games.broadcast(:finish_setup, String.to_integer(socket.assigns.game_id))
    Games.change_game_phase(socket.assigns.game_id, "BOARD")
    {:noreply, socket}
  end

  def handle_info({:finish_setup}, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.BoardLive, %{
      game_id: socket.assigns.game_id,
      player_id: socket.assigns.player.id
    }))}
  end

  def handle_info({:update_game, event}, socket) do
    {_, game} = event
    socket = assign(socket, red_challenge_id: game.red_challenge_id, blue_challenge_id: game.blue_challenge_id)
    {:noreply, socket}
  end

  def get_card_header(card_id) do
    if card_id do
      card = Cards.get_card!(card_id)
      card.header
    else
      ""
    end
  end

  def get_card_prompt(card_id) do
    if card_id do
      card = Cards.get_card!(card_id)
      card.prompt
    else
      ""
    end
  end

end
