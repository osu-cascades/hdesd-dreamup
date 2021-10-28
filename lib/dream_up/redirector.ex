defmodule DreamUp.Redirector do

  use DreamUpWeb, :controller

  def validate_game_phase(game, player, phase, socket) do
    if game.phase !== phase do
      IO.inspect("INCORRECT PHASE")
      case game.phase do
        "LOBBY" ->
          Phoenix.Controller.redirect(socket, to: Routes.live_path(socket, DreamUpWeb.LobbyLive, %{code: game.code}))
        "SETUP" ->
          Phoenix.Controller.redirect(socket, to: Routes.live_path(socket, DreamUpWeb.SetupLive, %{game_id: game.id, player_id: player.id}))
        "BOARD" ->
          Phoenix.Controller.redirect(socket, to: Routes.live_path(socket, DreamUpWeb.BoardLive, %{game_id: game.id, player_id: player.id}))
        "AWARD" ->
          Phoenix.Controller.redirect(socket, to: Routes.live_path(socket, DreamUpWeb.AwardsLive, %{game_id: game.id, player_id: player.id}))
      end
    else
      IO.inspect("VALID PHASE")
      socket
    end
  end

end
