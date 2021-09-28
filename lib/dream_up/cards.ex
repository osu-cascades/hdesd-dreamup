defmodule DreamUp.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  alias DreamUp.Cards.Card
  alias DreamUp.Games

  @method_card_map %{1 => "Empathize", 2 => "Define", 3 => "Ideate", 4 => "Prototype", 5 => "Test", 6 => "Mindset"}

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end

  def start_spinner_state(game, pivot_to_remove \\ nil, last_card \\ nil) do
    used_card_ids = [game.method_1_id,
                     game.method_2_id,
                     game.method_3_id,
                     game.method_4_id,
                     game.method_5_id,
                     game.method_6_id,
                     game.method_7_id,
                     game.method_8_id,
                     game.method_9_id,
                     game.red_pivoted_method_id,
                     game.blue_pivoted_method_id
                    ]
    method_type = get_random_method_type(game.round_number, used_card_ids)
    card_list = list_cards()
    matched_cards = Enum.filter(card_list, fn card ->
      match?(%{type: ^method_type}, card)
    end)
    picked_card = pick_card(matched_cards, used_card_ids)
    case pivot_to_remove do
      "red" ->
        Games.update_game(game, %{"time_left" => ~T[00:00:10], "round_state" => "SPINNER", "red_pivot_token" => false, "red_pivoted_method_id" => last_card.id, ("method_" <> Integer.to_string(game.round_number) <> "_id") => picked_card.id})
      "blue" ->
        Games.update_game(game, %{"time_left" => ~T[00:00:10], "round_state" => "SPINNER", "blue_pivot_token" => false, "blue_pivoted_method_id" => last_card.id, ("method_" <> Integer.to_string(game.round_number) <> "_id") => picked_card.id})
      nil ->
        IO.inspect(game.round_number + 1)
        Games.update_game(game, %{"time_left" => ~T[00:00:10], "round_state" => "SPINNER", "round_number" => game.round_number + 1, ("method_" <> Integer.to_string(game.round_number + 1) <> "_id") => picked_card.id})
    end
    Games.broadcast({:ok, picked_card}, :select_card, game.id)
  end

  def get_random_method_type(round_number, used_card_ids, last_round_method_type \\ nil) do
    case round_number do
      0 ->
        @method_card_map[:rand.uniform(4)]
      8 ->
        "Tell"
      _ ->
        confirmed_last_round_method_type = if last_round_method_type do
          last_round_method_type
        else
          IO.inspect(used_card_ids)
          get_card!(Enum.at(used_card_ids, round_number - 1)).type
        end
        new_method_type = @method_card_map[:rand.uniform(6)]
        if confirmed_last_round_method_type === new_method_type do
          get_random_method_type(round_number, used_card_ids, confirmed_last_round_method_type)
        else
          new_method_type
        end
    end
  end

  def pick_card(card_list, used_card_ids) do
    picked_card = Enum.random(card_list)
    card_list_ids = Enum.map(card_list, fn card -> card.id end)
    if !Enum.all?(card_list_ids, fn x -> x in used_card_ids end) && Enum.member?(used_card_ids, picked_card.id) do
      pick_card(card_list, used_card_ids)
    else
      picked_card
    end
  end
end
