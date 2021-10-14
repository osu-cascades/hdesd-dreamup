defmodule DreamUp.Awards.Award do
  use Ecto.Schema
  import Ecto.Changeset

  schema "awards" do
    field :card_id, :integer
    field :game_id, :integer
    field :team, :string

    timestamps()
  end

  @doc false
  def changeset(award, attrs) do
    award
    |> cast(attrs, [:game_id, :team, :card_id])
    |> validate_required([:game_id, :team, :card_id])
  end
end
