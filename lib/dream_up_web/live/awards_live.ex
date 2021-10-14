defmodule DreamUpWeb.AwardsLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games
  alias DreamUp.Players
  alias DreamUp.Cards

  def mount(_params, _session, socket) do
    socket = assign(socket, cards: Cards.list_cards())
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, game: Games.get_game!(params["game_id"]), player: Players.get_player!(params["player_id"]))}
  end






end
