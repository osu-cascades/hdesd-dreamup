defmodule DreamUpWeb.SetupLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Cards
  alias DreamUp.Games
  alias DreamUp.Players


  def mount(_params, _session, socket) do
    cards = Cards.list_cards()
    socket = assign(socket, cards: cards, blue_challenge_id: nil, red_challenge_id: nil, class: "")
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Games.subscribe(String.to_integer(params["game_id"]))
    player = Players.get_player!(params["player_id"])
    socket = assign(socket, game_id: params["game_id"], player: player)
    {:noreply, socket}
  end

  def handle_event("challenge-click", %{"card-id" => card_id}, socket) do
    IO.inspect(socket.assigns.game_id)
    IO.puts("challenge-click event")
    Games.select_challenge(socket.assigns.game_id, String.to_integer(card_id), socket.assigns.player.team)
    {:noreply, assign(socket, class: "flip-card")}
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
