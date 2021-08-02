defmodule DreamUpWeb.SetupLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Cards
  alias DreamUp.Cards.Card
  alias DreamUp.Games


  def mount(_params, _session, socket) do
    cards = Cards.list_cards()

    # changeset = Card.change_card(%Card{})

    # socket = assign(socket, changeset: changeset, id: false, editing: false)
    socket = assign(socket, cards: cards, game_id: 11, team: "blue")
    {:ok, socket}
  end

  def handle_event("challenge-click", %{"card-id" => card_id}, socket) do
    Games.select_challenge(socket.assigns.game_id, String.to_integer(card_id), socket.assigns.team)
    {:noreply, socket}
  end

end
