defmodule DreamUp.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo
  import Phoenix.LiveView

  alias DreamUp.Players.Player

  def subscribe do
    Phoenix.PubSub.subscribe(DreamUp.PubSub, "players")
  end

  def list_players_in_game(game_id) do
    Repo.all(from p in Player, order_by: [desc: p.id], where: [game_id: ^game_id])
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    final_attrs = add_player_from_lobby(attrs)
    %Player{}
    |> Player.changeset(final_attrs)
    |> Repo.insert()
    |> broadcast(:player_event)
  end

  def add_player_from_lobby(attrs \\ %{}) do
    if Enum.count(list_players_in_game(attrs.game_id)) === 0 do
      Map.put(attrs, :game_admin, true)
    else
      attrs
    end

  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
    |> broadcast(:player_event)
  end

  def broadcast({:ok, player}, event) do
     Phoenix.PubSub.broadcast(
       DreamUp.PubSub,
       "players",
       {event}
     )
     {:ok, player}
  end

  def broadcast({:error, _reason} = error, _event), do: error

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
    |> broadcast(:player_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  def change_team(%Player{} = player) do
    case player.team do
      "blue" ->
        update_player(player, %{team: "red"})
      "red" ->
        update_player(player, %{team: "blue"})
    end
    update_team_leaders(player.game_id)
  end

  def update_team_leaders(game_id) do
    for p <- list_players_in_game(game_id) do
      update_player(p, %{team_leader: nil})
    end

    first_red_player = find_first_player_on_team("red", game_id)
    if first_red_player !== -1 do
      update_player(first_red_player, %{team_leader: "red"})
    end
    first_blue_player = find_first_player_on_team("blue", game_id)
    if first_blue_player !== -1 do
      update_player(first_blue_player, %{team_leader: "blue"})
    end
  end

  def list_players_in_team(team, game_id) do
    Enum.filter(list_players_in_game(game_id), fn player ->
      match?(%{team: ^team}, player)
    end)
  end

  def find_first_player_on_team(team, game_id) do
    players_in_team = list_players_in_team(team, game_id)
    if Enum.count(players_in_team) > 0 do
      Enum.min_by(players_in_team, fn player -> player.id end)
    else
      -1
    end
  end

  def push_header_event(socket, player) do
    push_event(socket, "updateHeader", %{name: player.name, team: player.team, team_leader: player.team_leader, is_admin: player.game_admin})
  end

end
