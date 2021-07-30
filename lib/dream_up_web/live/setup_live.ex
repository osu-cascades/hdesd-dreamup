defmodule DreamUpWeb.SetupLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Cards
  alias DreamUp.Cards.Card


  def mount(_params, _session, socket) do
    cards = Cards.list_cards()

    # changeset = Card.change_card(%Card{})

    # socket = assign(socket, changeset: changeset, id: false, editing: false)
    socket = assign(socket, cards: cards)
    {:ok, socket}
  end

end
