defmodule DreamUp.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :prompt, :string
    field :header, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:type, :header, :prompt])
    |> validate_required([:type, :prompt])
  end
end
