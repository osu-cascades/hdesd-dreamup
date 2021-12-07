defmodule DreamUpWeb.InstructionsLive do

  use DreamUpWeb, :live_view

  @max_step 6

  def mount(_params, _session, socket) do
    {:ok, assign(socket, step: 1)}
  end

  def handle_event("back", _, socket) do
    if socket.assigns.step == 1 do
      {:noreply, redirect(socket, to: Routes.home_path(socket, :index))}
    else
      {:noreply, assign(socket, step: socket.assigns.step - 1)}
    end
  end

  def handle_event("next", _, socket) do
    if socket.assigns.step == @max_step do
      {:noreply, redirect(socket, to: Routes.home_path(socket, :index))}
    else
      {:noreply, assign(socket, step: socket.assigns.step + 1)}
    end
  end

end
