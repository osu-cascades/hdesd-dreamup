defmodule DreamUpWeb.HomeLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Games

  def mount(_params, _session, socket) do
    {:ok, assign(socket, error: nil)}
  end

  def handle_params(params, _url, socket) do
    if params["error"] !== nil do
      {:noreply, assign(socket, error: params["error"])}
    else
      {:noreply, socket}
    end
  end

  def handle_event("join-game", %{"game_code" => code}, socket) do
    # send("/lobby/?code=#{code}")
    socket = assign(socket, code: code)
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.LobbyLive, %{code: code}))}
  end

  def handle_event("create-game", _, socket) do
    code = Games.generate_game_code()
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.LobbyLive, %{code: code}))}
  end

end
