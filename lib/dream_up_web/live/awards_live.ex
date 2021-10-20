defmodule DreamUpWeb.AwardsLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards
  alias DreamUp.Awards

  alias DreamUp.Repo

  def mount(_params, _session, socket) do
    socket = assign(socket, cards: Cards.list_cards(), awards: Awards.list_awards())
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, game: Games.get_game!(params["game_id"]), player: Players.get_player!(params["player_id"]))}
  end

  def handle_event("award-click", %{"card-id" => card_id}, socket) do
    case socket.assigns.player.team do
      "red" ->
        Awards.create_award(%{game_id: socket.assigns.game.id, team: "blue", card_id: String.to_integer(card_id)})
      "blue" ->
        Awards.create_award(%{game_id: socket.assigns.game.id, team: "red", card_id: String.to_integer(card_id)})
    end
    {:noreply, socket}
  end

  def get_award_cards(cards, awards, game_id, player_team) do
    our_teams_awards = Enum.filter(awards, fn award ->
      match?(%{game_id: ^game_id, team: ^player_team}, award)
    end)
    Enum.filter(cards, fn card ->
      match?(%{id: card.id}, card)
    end)
  end

end
