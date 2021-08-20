defmodule DreamUp.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

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
      Map.put(attrs, :permissions, "admin")
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
  end

  def find_first_player_on_team(team, game_id) do
    players_in_game = list_players_in_game(game_id)
    players_in_team = Enum.filter(players_in_game, fn player ->
      match?(%{team: ^team}, player)
    end)
    if Enum.count(players_in_team) > 0 do
      Enum.min_by(players_in_team, fn player -> player.id end)
    else
      -1
    end
    # players_sorted = Enum.sort(players_in_team, fn player1, player2  ->
    #   player1.id >= player2.id
    # end)
    # Enum.min
    # Enum.at(0)
    # IO.inspect(players_in_team)
  end
end
