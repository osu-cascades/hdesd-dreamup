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
    field :method_1_id, :integer
    field :method_2_id, :integer
    field :method_3_id, :integer
    field :method_4_id, :integer
    field :method_5_id, :integer
    field :method_6_id, :integer
    field :method_7_id, :integer
    field :method_8_id, :integer
    field :method_9_id, :integer
    field :round_number, :integer
    field :red_pivoted_method_id, :integer
    field :blue_pivoted_method_id, :integer
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :code,
      :blue_challenge_id,
      :red_challenge_id,
      :time_left,
      :red_add_time_token,
      :blue_add_time_token,
      :round_state,
      :red_pivot_token,
      :blue_pivot_token,
      :method_1_id,
      :method_2_id,
      :method_3_id,
      :method_4_id,
      :method_5_id,
      :method_6_id,
      :method_7_id,
      :method_8_id,
      :method_9_id,
      :round_number,
      :blue_pivoted_method_id,
      :red_pivoted_method_id
    ])
    |> validate_required([:code, :time_left, :red_add_time_token, :blue_add_time_token, :round_state, :red_pivot_token, :blue_pivot_token, :round_number])
  end
end
