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
    socket = assign(socket, cards: cards, blue_challenge_id: nil, red_challenge_id: nil, class: '')
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if params["team"] != "red" and params["team"] != "blue" do
      IO.puts("ERROR PARAMS")
      IO.inspect(params)
    end
    socket = assign(socket, game_id: params["game_id"], player_id: params["player_id"], team: params["team"])
    {:noreply, socket}
  end

  def handle_event("challenge-click", %{"card-id" => card_id}, socket) do
    if socket.assigns.team != "red" and socket.assigns.team != "blue" do
      IO.puts("ERROR SOCKET")
      IO.inspect(socket.assigns.team)
    end
    Games.select_challenge(socket.assigns.game_id, String.to_integer(card_id), socket.assigns.team)
    {:noreply, assign(socket, class: "flip-card")}
  end

  def handle_info({:game_update, game}, socket) do
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
