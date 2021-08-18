defmodule DreamUp.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  alias DreamUp.Games.Game
  alias DreamUp.Code

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(DreamUp.PubSub, "games" <> Integer.to_string(game_id))
  end

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  def code_exists(code) do
    Repo.all(from g in Game, order_by: [desc: g.id], where: [code: ^code]) != []
  end

  def generate_game_code do
    code = Code.random_code()
    code_exists = code_exists(code)
    case code_exists do
      true ->
        generate_game_code()
      false ->
        create_game(%{code: code, name: "why"})
    end
    code
  end

  def get_game_id_from_code(code) do
    results = Repo.all(from g in Game, order_by: [desc: g.id], where: [code: ^code])
    if Enum.count(results) === 0 do
      -1
    else
      [head | _tail] = Repo.all(from g in Game, order_by: [desc: g.id], where: [code: ^code])
      head.id
    end
  end

  # Broadcast function with game event attached to it
  def broadcast(event, event_name, game_id) do
    Phoenix.PubSub.broadcast(
      DreamUp.PubSub,
      "games" <> Integer.to_string(game_id),
      {event_name, event}
    )
  end

  # Broadcast function with no additional arguments
  def broadcast(event_name, game_id) do
    Phoenix.PubSub.broadcast(
      DreamUp.PubSub,
      "games" <> Integer.to_string(game_id),
      {event_name}
    )
  end


  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
    |> broadcast(:update_game, game.id)
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def select_challenge(id, card_id, team) do
    game = get_game!(id)
    case team do
      "red" ->
        update_game(game, %{blue_challenge_id: card_id})
      "blue" ->
        update_game(game, %{red_challenge_id: card_id})
    end
  end

end
