defmodule DreamUp.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :prompt, :string
    field :header, :string
    field :type, :string
    field :gameplay_time, :time
    field :discussion_time, :time

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:type, :header, :promp, :gameplay_time, :discussion_time])
    |> validate_required([:type, :prompt])
  end
end
