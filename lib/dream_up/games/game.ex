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
<<<<<<< HEAD
    field :current_method, :string
    field :picked_method_id, :integer
=======
    field :round_state, :string
    field :red_pivot_token, :boolean
    field :blue_pivot_token, :boolean
>>>>>>> 892005c71bbfc8daa9cc5ac2075be5c1cbdc23c9
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
<<<<<<< HEAD
    |> cast(attrs, [:code, :blue_challenge_id, :red_challenge_id, :time_left, :red_add_time_token,
     :blue_add_time_token, :current_method, :picked_method_id])
    |> validate_required([:code, :time_left, :red_add_time_token, :blue_add_time_token])
=======
    |> cast(attrs, [:code, :blue_challenge_id, :red_challenge_id, :time_left, :red_add_time_token, :blue_add_time_token, :round_state, :red_pivot_token, :blue_pivot_token])
    |> validate_required([:code, :time_left, :red_add_time_token, :blue_add_time_token, :round_state, :red_pivot_token, :blue_pivot_token])
>>>>>>> 892005c71bbfc8daa9cc5ac2075be5c1cbdc23c9
  end
end
