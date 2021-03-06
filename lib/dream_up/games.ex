defmodule DreamUp.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  alias DreamUp.Games.Game
  alias DreamUp.Cards
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
        create_game(%{code: code, name: "why", time_left: ~T[00:00:00], red_add_time_token: true, blue_add_time_token: true, round_state: "GAME_START",
          red_pivot_token: true, blue_pivot_token: true, round_number: 0, phase: "LOBBY"})
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
  def broadcast(data, event_name, game_id) do
    Phoenix.PubSub.broadcast(
      DreamUp.PubSub,
      "games" <> Integer.to_string(game_id),
      {event_name, data}
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

  def select_challenge(id, card_id, team, is_single_team_game) do
    game = get_game!(id)
    if is_single_team_game do
      case team do
        "red" ->
          update_game(game, %{red_challenge_id: card_id})
        "blue" ->
          update_game(game, %{blue_challenge_id: card_id})
      end
    else
      case team do
        "red" ->
          update_game(game, %{blue_challenge_id: card_id})
        "blue" ->
          update_game(game, %{red_challenge_id: card_id})
      end
    end
  end

  def change_game_phase(game_id, phase) do
    update_game(get_game!(game_id), %{phase: phase})
  end

  def add_time(game, team) do
    case team do
       "blue" ->
          update_game(game, %{time_left: Time.add(game.time_left, 300), blue_add_time_token: false})
        "red" ->
          update_game(game, %{time_left: Time.add(game.time_left, 300), red_add_time_token: false})
    end
  end

  def decrease_time(game, method_card) do
    if Time.compare(game.time_left, ~T[00:00:00]) === :gt do
      update_game(game, %{time_left: Time.add(game.time_left, -1)})
    else
      case game.round_state do
        "SPINNER" ->
          update_game(game, %{round_state: "GAMEPLAY", time_left: method_card.gameplay_time})
        "GAMEPLAY" ->
          update_game(game, %{round_state: "DISCUSSION", time_left: method_card.discussion_time})
        "DISCUSSION" ->
          if game.round_number === 9 do
            change_game_phase(game.id, "AWARD")
            broadcast(:finish_game, game.id)
          else
            broadcast(:round_over, game.id)
            Cards.start_spinner_state(game)
          end
        "GAME_START" ->
          Cards.start_spinner_state(game)
      end
    end
  end

  def get_method_card_list(game) do
    [game.method_1_id, game.method_2_id, game.method_3_id, game.method_4_id, game.method_5_id,
     game.method_6_id, game.method_7_id, game.method_8_id, game.method_9_id]
  end

end
