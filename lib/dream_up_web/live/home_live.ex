defmodule DreamUpWeb.HomeLive do

  use DreamUpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # def handle_params(params, _url, socket) do
  #   {:ok, socket}
  # end

  def handle_event("start-playing", _, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.StartLive))}
  end

  def handle_event("view-instructions", _, socket) do
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.InstructionsLive))}
  end

end
