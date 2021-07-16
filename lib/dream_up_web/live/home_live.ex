defmodule DreamUpWeb.HomeLive do

  use DreamUpWeb, :live_view

  def mount(_params, _session, socket) do

    {:ok, socket}
  end

  def handle_event("join-game", %{"game_code" => code}, socket) do
    # send("/lobby/?code=#{code}")
    socket = assign(socket, code: code)
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.LobbyLive, %{code: code}))}
  end

end
