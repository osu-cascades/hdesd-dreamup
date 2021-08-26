defmodule DreamUp.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :game_id, :integer
    field :team, :string
    field :team_leader, :string
    field :character, :string
    field :game_admin, :boolean

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :game_id, :team, :team_leader, :character, :game_admin])
    |> validate_required([:name, :game_id, :team, :character])
  end
end
