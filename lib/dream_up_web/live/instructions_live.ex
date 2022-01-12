defmodule DreamUpWeb.InstructionsLive do

  use DreamUpWeb, :live_view

  @max_step 6

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

end
