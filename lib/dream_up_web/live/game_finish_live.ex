defmodule DreamUpWeb.GameFinishLive do

  use DreamUpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("go-home", _, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.StartLive))}
  end

end
