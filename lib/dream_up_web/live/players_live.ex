defmodule DreamUpWeb.PlayersLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Players
  alias DreamUp.Players.Player

  def mount(_params, _session, socket) do
    if connected?(socket), do: Players.subscribe()

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
        socket = assign(socket, changest: changeset)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changest: changeset)
        {:noreply, socket}
    end

  end

  def handle_event("edit-name", %{"id" => id}, socket) do

    player = Players.get_player!(id)

    {:ok, _player} =
      Players.update_player(
        player,
        %{name: "John Doe"}
      )

    players = Players.list_players()

    socket = assign(socket, players: players)
    {:noreply, socket}
  end

  def handle_event("delete-name", %{"id" => id}, socket) do

    player = Players.get_player!(id)

    {:ok, _player} = Players.delete_player(player)

    players = Players.list_players()

    socket = assign(socket, players: players)
    {:noreply, socket}
  end

  def handle_info({:player_deleted, player}, socket) do
    socket =
      update(
        socket,
        :players,
        fn players -> [player | players] end
      )
    {:noreply, socket}
  end

  def handle_info({:player_created, player}, socket) do
    socket =
      update(
        socket,
        :players,
        fn players -> [player | players] end
      )
    {:noreply, socket}
  end

  def handle_info({:player_updated, player}, socket) do
    socket =
      update(
        socket,
        :players,
        fn players -> [player | players] end
      )
    {:noreply, socket}
  end
end
