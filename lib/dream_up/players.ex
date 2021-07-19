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
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:player_event)
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
       {event, player}
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
end
