defmodule DreamUpWeb.LobbyLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Players
  alias DreamUp.Players.Player
  alias DreamUp.Games

  def mount(_params, _session, socket) do
    if connected?(socket), do: Players.subscribe()

    changeset = Players.change_player(%Player{})

    socket = assign(socket, changeset: changeset, id: false, editing: false)
    {:ok, socket, temporary_assigns: [players: []]}
  end

  def handle_params(params, _url, socket) do
    code = params["code"]
    game_id = Games.get_game_id_from_code(code)
    players = Players.list_players_in_game(game_id)
    socket = assign(socket, game_id: game_id, code: code, players: players)
    {:noreply, socket}
  end

  def handle_event("save", %{"player" => name_param}, socket) do
    params = %{name: name_param["name"], game_id: socket.assigns.game_id, team: "blue"}
    case Players.create_player(params) do
      {:ok, player} ->
        socket = update(socket, :players, fn players -> [ player | players ] end)

        changeset = Players.change_player(%Player{})
        socket = assign(socket, changest: changeset, id: player.id)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changest: changeset)
        {:noreply, socket}
    end

  end

  def handle_event("edit-name", %{"player" => name}, socket) do
    player = Players.get_player!(socket.assigns.id)

    {:ok, _player} =
      Players.update_player(
        player,
        %{name: name}
      )

    players = Players.list_players_in_game(socket.assigns.game_id)

    socket = assign(socket, players: players)
    {:noreply, socket}
  end

  def handle_event("editing", %{"editing" => editing}, socket) do
    socket = assign(socket, editing: editing)
    {:noreply, socket}
  end

  def handle_event("delete-name", %{"id" => id}, socket) do

    player = Players.get_player!(id)

    {:ok, _player} = Players.delete_player(player)

    players = Players.list_players_in_game(socket.assigns.game_id)

    socket = assign(socket, players: players, id: false)
    {:noreply, socket}
  end

  def handle_info({:player_event, player}, socket) do
    socket =
      update(
        socket,
        :players,
        fn players -> [player | players] end
      )
    {:noreply, socket}
  end

  def is_editing(assigns) do
    assigns.editing
  end

end
