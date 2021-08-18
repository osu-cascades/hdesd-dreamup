defmodule DreamUpWeb.LobbyLive do

  use DreamUpWeb, :live_view

  alias DreamUp.Players
  alias DreamUp.Players.Player
  alias DreamUp.Games

  def mount(_params, _session, socket) do
    if connected?(socket), do: Players.subscribe()

    changeset = Players.change_player(%Player{})

    socket = assign(socket, changeset: changeset, id: false, editing: false)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    game_id = Games.get_game_id_from_code(params["code"])
    if game_id === -1 do
      {:noreply, redirect(socket, to: Routes.home_path(socket, :index, %{error: "code"}))}
    else
      if connected?(socket), do: Games.subscribe(game_id)
      {:noreply, assign(socket,
        game_id: game_id,
        code: params["code"],
        players: Players.list_players_in_game(game_id)
      )}
    end
  end

  def handle_event("save", %{"player" => player_params}, socket) do
    params = %{name: player_params["name"], game_id: socket.assigns.game_id, team: player_params["team"]}
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

  def handle_event("edit-name", %{"player" => params}, socket) do
    player = Players.get_player!(socket.assigns.id)

    {:ok, _player} =
      Players.update_player(
        player,
        %{name: params["name"]}
      )

    players = Players.list_players_in_game(socket.assigns.game_id)

    socket = assign(socket, players: players, editing: false)
    {:noreply, socket}
  end

  def handle_event("editing", %{"editing" => editing}, socket) do
    case editing do
        "true" ->
          {:noreply, assign(socket, editing: true)}
        "false" ->
          {:noreply, assign(socket, editing: false)}
    end
  end

  def handle_event("delete-name", %{"id" => id}, socket) do

    player = Players.get_player!(id)

    {:ok, _player} = Players.delete_player(player)

    players = Players.list_players_in_game(socket.assigns.game_id)

    socket = assign(socket, players: players, id: false)
    {:noreply, socket}
  end

  def handle_event("change-team", %{"id" => id}, socket) do

    player = Players.get_player!(id)

    Players.change_team(player)

    players = Players.list_players_in_game(socket.assigns.game_id)

    socket = assign(socket, players: players)
    {:noreply, socket}
  end

  def handle_event("begin-setup", _, socket) do
    Games.begin_setup(socket.assigns.game_id)
    {:noreply, socket}
  end

  def get_current_player(socket) do
    id = socket.assigns.id
    Enum.find(socket.assigns.players, fn(player) ->
      match?(%{id: ^id}, player)
    end)
  end

  def handle_info({:player_event}, socket) do
    socket =
      assign(
        socket,
        players: Players.list_players_in_game(socket.assigns.game_id)
      )
    {:noreply, socket}
  end

  def handle_info({:update_game}, socket) do
    # socket = assign(socket, key: value)
    {:noreply, socket}
  end

  def handle_info({:begin_setup}, socket) do
    game_id = socket.assigns.game_id
    player_id = socket.assigns.id
    current_player = get_current_player(socket)
    {:noreply, redirect(socket, to: Routes.live_path(socket, DreamUpWeb.SetupLive, %{game_id: game_id, player_id: player_id, team: current_player.team}))}
  end

  def own_player_is_admin(id, players) do
    player = Enum.find(players, fn(player) ->
      match?(%{id: ^id}, player)
    end)
    if player do
      player.permissions === "admin"
    else
      false
    end
  end

end
