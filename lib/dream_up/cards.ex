defmodule DreamUp.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  alias DreamUp.Cards.Card
  alias DreamUp.Games

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

  def get_random_card_from_method(method_type, game) do
    card_list = list_cards()
    matched_cards = Enum.filter(card_list, fn card ->
      match?(%{type: ^method_type}, card)
    end)
    picked_card = pick_card(matched_cards, game)
    Games.update_game(game, %{("method_" <> Integer.to_string(game.round_number) <> "_id") => picked_card.id})
    Games.broadcast({:ok, picked_card}, :select_card, game.id)
  end

  #Fix 119
  def pick_card(card_list, game) do
    picked_card = Enum.random(card_list)
    used_card_ids = Enum.map(1..9, fn n -> game["method_" <> Integer.to_string(n) <> "_id"] end)
    if Enum.member?(used_card_ids, picked_card.id) do
      pick_card(card_list, game)
    else
      picked_card
    end
  end
end
