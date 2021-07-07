defmodule DreamUpWeb.PlayersLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Players
  alias DreamUp.Players.Player

  def mount(_params, _session, socket) do
    players = Players.list_players()

    changeset = Players.change_player(%Player{})

    socket = assign(socket, players: players, changeset: changeset)
    {:ok, socket, temporary_assigns: [players: []]}
  end

  def handle_event("save", %{"player" => params}, socket) do
    case Players.create_player(params) do
      {:ok, player} ->

      socket = update(socket, :players, fn players -> [ player | players ] end)

      changeset = Players.change_player(%Player{})
      {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changest: changeset)
        {:noreply, socket}
    end

  end
end
