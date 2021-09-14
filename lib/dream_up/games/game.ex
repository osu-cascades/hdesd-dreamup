defmodule DreamUp.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :code, :string
    field :blue_challenge_id, :integer
    field :red_challenge_id, :integer
    field :time_left, :time
    field :red_add_time_token, :boolean
    field :blue_add_time_token, :boolean
    field :current_method, :string
    field :picked_method_id, :integer
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:code, :blue_challenge_id, :red_challenge_id, :time_left, :red_add_time_token,
     :blue_add_time_token, :current_method, :picked_method_id])
    |> validate_required([:code, :time_left, :red_add_time_token, :blue_add_time_token])
  end
end
