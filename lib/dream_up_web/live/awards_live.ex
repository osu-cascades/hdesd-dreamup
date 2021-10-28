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
    {:noreply, assign(socket, game: Games.get_game!(params["game_id"]), player: Players.get_player!(params["player_id"]), is_single_team_game: length(
      Players.list_players_in_team(
        "red", params["game_id"]
       )
     ) === 0 || length(
       Players.list_players_in_team(
         "blue", params["game_id"]
       )
     ) === 0)}
  end

  def handle_event("award-click", %{"card-id" => card_id}, socket) do
    unless socket.assigns.is_single_team_game do
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
    else
      case socket.assigns.player.team do
        "blue" ->
          unless Awards.exists(socket.assigns.awards, socket.assigns.game.id, "blue", String.to_integer(card_id)) do
            Awards.create_award(%{game_id: socket.assigns.game.id, team: "blue", card_id: String.to_integer(card_id)})
          end
        "red" ->
          unless Awards.exists(socket.assigns.awards, socket.assigns.game.id, "red", String.to_integer(card_id)) do
            Awards.create_award(%{game_id: socket.assigns.game.id, team: "red", card_id: String.to_integer(card_id)})
          end
      end
    end
    {:noreply, socket}
  end

  def handle_event("remove-award", %{"award-id" => award_id}, socket) do
    String.to_integer(award_id)
    |> Awards.get_award!()
    |> Awards.delete_award()
    {:noreply, socket}
  end

  def handle_info({:create_award, event}, socket) do
    {_, award} = event
    {:noreply, update(socket, :awards, fn awards -> awards ++ [award] end)}
  end

  def handle_info({:delete_award, event}, socket) do
    {_, deleted_award} = event
    # TODO: Change deleted_award's metadata to say it is :loaded so that it can be matched and deleted from the list of awards in the socket. Right now, we're just getting the list of values from the db again.

    # award_to_delete = Map.delete(deleted_award, :__meta__)
    # |> Map.put(:__meta__, %Ecto.Schema.Metadata{:loaded, "awards"})
    # awards = List.delete(socket.assigns.awards, award_to_delete)

    awards = Awards.list_awards()

    {:noreply, assign(socket, awards: awards)}
  end

end
