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
    field :round_state, :string
    field :red_pivot_token, :boolean
    field :blue_pivot_token, :boolean
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:code, :blue_challenge_id, :red_challenge_id, :time_left, :red_add_time_token, :blue_add_time_token, :round_state, :red_pivot_token, :blue_pivot_token])
    |> validate_required([:code, :time_left, :red_add_time_token, :blue_add_time_token, :round_state, :red_pivot_token, :blue_pivot_token])
  end
end
