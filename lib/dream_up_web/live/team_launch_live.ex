defmodule DreamUpWeb.TeamLaunchLive do

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
    game = Games.get_game!(params["game_id"])
    socket = assign(socket, game: game, player: player,
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

    {status, route} = Redirector.validate_game_phase(game, player.id, "TEAM_LAUNCH", socket)
    if status !== :ok do
      {:noreply, redirect(socket, to: route)}
    else
      {:noreply, Players.push_header_event(socket, player)}
    end
  end

  def handle_event("finish-team-launch", _, socket) do
    Games.broadcast(:finish_team_launch, socket.assigns.game.id)
    Games.change_game_phase(socket.assigns.game.id, "SETUP")
    {:noreply, socket}
  end

  def handle_info({:finish_team_launch}, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.SetupLive, %{
      game_id: socket.assigns.game.id,
      player_id: socket.assigns.player.id
    }))}
  end

end
