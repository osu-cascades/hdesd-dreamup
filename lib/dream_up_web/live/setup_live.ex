defmodule DreamUpWeb.SetupLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Cards
  alias DreamUp.Cards.Card
  alias DreamUp.Games


  def mount(_params, _session, socket) do
    if connected?(socket), do: Games.subscribe()

    cards = Cards.list_cards()

    # changeset = Card.change_card(%Card{})

    # socket = assign(socket, changeset: changeset, id: false, editing: false)
    socket = assign(socket, cards: cards, game_id: 11, team: "blue", blue_challenge_id: nil, red_challenge_id: nil)
    {:ok, socket}
  end

  def handle_event("challenge-click", %{"card-id" => card_id}, socket) do
    Games.select_challenge(socket.assigns.game_id, String.to_integer(card_id), socket.assigns.team)
    {:noreply, socket}
  end

  def handle_info({:game_update, game}, socket) do
    socket = assign(socket, red_challenge_id: game.red_challenge_id, blue_challenge_id: game.blue_challenge_id)
    {:noreply, socket}
  end

end
