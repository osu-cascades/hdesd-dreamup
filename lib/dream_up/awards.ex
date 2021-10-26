defmodule DreamUp.Awards do
  @moduledoc """
  The Awards context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  alias DreamUp.Awards.Award

  def subscribe do
    Phoenix.PubSub.subscribe(DreamUp.PubSub, "awards")
  end

  def broadcast(data, event_name) do
    Phoenix.PubSub.broadcast(
      DreamUp.PubSub,
      "awards",
      {event_name, data}
    )
  end

  @doc """
  Returns the list of awards.

  ## Examples

      iex> list_awards()
      [%Award{}, ...]

  """
  def list_awards do
    Repo.all(Award)
  end

  @doc """
  Gets a single award.

  Raises `Ecto.NoResultsError` if the Award does not exist.

  ## Examples

      iex> get_award!(123)
      %Award{}

      iex> get_award!(456)
      ** (Ecto.NoResultsError)

  """
  def get_award!(id), do: Repo.get!(Award, id)

  @doc """
  Creates a award.

  ## Examples

      iex> create_award(%{field: value})
      {:ok, %Award{}}

      iex> create_award(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_award(attrs \\ %{}) do
    %Award{}
    |> Award.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:create_award)
  end

  @doc """
  Updates a award.

  ## Examples

      iex> update_award(award, %{field: new_value})
      {:ok, %Award{}}

      iex> update_award(award, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_award(%Award{} = award, attrs) do
    award
    |> Award.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a award.

  ## Examples

      iex> delete_award(award)
      {:ok, %Award{}}

      iex> delete_award(award)
      {:error, %Ecto.Changeset{}}

  """
  def delete_award(%Award{} = award) do
    Repo.delete(award)
    |> broadcast(:delete_award)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking award changes.

  ## Examples

      iex> change_award(award)
      %Ecto.Changeset{data: %Award{}}

  """
  def change_award(%Award{} = award, attrs \\ %{}) do
    Award.changeset(award, attrs)
  end

  def exists(awards, game_id, team, card_id) do
    awards_in_game = Enum.filter(awards, fn award ->
      match?(%{game_id: ^game_id}, award)
    end)
    awards_for_team = Enum.filter(awards_in_game, fn award ->
      match?(%{team: ^team}, award)
    end)
    chosen_awards = Enum.filter(awards_for_team, fn award ->
      match?(%{card_id: ^card_id}, award)
    end)
    length(chosen_awards) !== 0
  end
end
