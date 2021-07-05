defmodule DreamUpWeb.PlayersLive do


  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

end
