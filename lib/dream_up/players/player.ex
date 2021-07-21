defmodule DreamUp.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :game_id, :integer
    field :team, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :game_id, :team])
    |> validate_required([:name, :game_id, :team])
  end
end
