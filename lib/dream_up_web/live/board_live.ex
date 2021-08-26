defmodule DreamUpWeb.BoardLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games

  def mount(_params, _session, socket) do

    socket = assign(socket, round_active: false)
    {:ok, socket}
  end

  def handle_event("start-round", _, socket) do
    IO.inspect("starting round")
    Games.broadcast(:start_round, 1)
    # Games.select_challenge(socket.assigns.game_id, String.to_integer(card_id), socket.assigns.player.team)
    {:noreply, assign(socket, round_active: true)}
  end

  def handle_info({:start_round}, socket) do
    IO.inspect("assigning to socket")
    {:noreply, assign(socket, round_active: true)}
  end

end
