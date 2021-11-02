defmodule DreamUpWeb.AwardsLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards
  alias DreamUp.Awards
  alias DreamUp.Redirector

  def mount(_params, _session, socket) do
    socket = assign(socket, cards: Cards.list_cards(), awards: Awards.list_awards())
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: Awards.subscribe()
    new_socket = assign(socket, game: Games.get_game!(params["game_id"]), player: Players.get_player!(params["player_id"]), is_single_team_game: length(
      Players.list_players_in_team(
        "red", params["game_id"]
       )
     ) === 0 || length(
       Players.list_players_in_team(
         "blue", params["game_id"]
       )
     ) === 0)
    {status, route} = Redirector.validate_game_phase(new_socket.assigns.game, new_socket.assigns.player.id, "AWARD", new_socket)
    if status !== :ok do
      {:noreply, redirect(new_socket, to: route)}
    else
      {:noreply, new_socket}
    end
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
    deleted_award_id = deleted_award.id

    awards = Enum.reject(socket.assigns.awards, fn award ->
      match?(%{id: ^deleted_award_id}, award)
    end)

    {:noreply, assign(socket, awards: awards)}
  end

end
