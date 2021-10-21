defmodule DreamUpWeb.AwardsLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards
  alias DreamUp.Awards

  def mount(_params, _session, socket) do
    socket = assign(socket, cards: Cards.list_cards(), awards: Awards.list_awards())
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Awards.subscribe()
    {:noreply, assign(socket, game: Games.get_game!(params["game_id"]), player: Players.get_player!(params["player_id"]))}
  end

  def handle_event("award-click", %{"card-id" => card_id}, socket) do
    case socket.assigns.player.team do
      "red" ->
        unless Awards.exists(socket.assigns.awards, socket.assigns.game.id, "blue", String.to_integer(card_id)) do
          Awards.create_award(%{game_id: socket.assigns.game.id, team: "blue", card_id: String.to_integer(card_id)})
        end
      "blue" ->
        unless Awards.exists(socket.assigns.awards, socket.assigns.game.id, "red", String.to_integer(card_id)) do
          Awards.create_award(%{game_id: socket.assigns.game.id, team: "red", card_id: String.to_integer(card_id)})
        end
    end
    {:noreply, socket}
  end

  def handle_info({:create_award, event}, socket) do
    {_, award} = event
    {:noreply, update(socket, :awards, fn awards -> awards ++ [award] end)}
  end

end
