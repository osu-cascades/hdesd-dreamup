defmodule DreamUp.Redirector do

  use DreamUpWeb, :controller

  def validate_game_phase(game, player_id, phase, socket) do
    if game.phase !== phase do
      case game.phase do
        "LOBBY" ->
          {:error, Routes.live_path(socket, DreamUpWeb.LobbyLive, %{code: game.code})}
        "SETUP" ->
          {:error, Routes.live_path(socket, DreamUpWeb.SetupLive, %{game_id: game.id, player_id: player_id})}
        "BOARD" ->
          {:error, Routes.live_path(socket, DreamUpWeb.BoardLive, %{game_id: game.id, player_id: player_id})}
        "AWARD" ->
          {:error, Routes.live_path(socket, DreamUpWeb.AwardsLive, %{game_id: game.id, player_id: player_id})}
      end
    else
      {:ok, nil}
    end
  end

end
