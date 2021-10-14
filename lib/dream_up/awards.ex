defmodule DreamUp.Awards do
  @moduledoc """
  The Awards context.
  """

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  alias DreamUp.Awards.Award

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
end
