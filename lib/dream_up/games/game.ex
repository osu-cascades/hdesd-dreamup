defmodule DreamUp.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :code, :string
    field :blue_challenge_id, :integer
    field :red_challenge_id, :integer
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:code, :blue_challenge_id, :red_challenge_id])
    |> validate_required([:code])
  end
end
