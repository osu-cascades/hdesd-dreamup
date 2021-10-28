defmodule DreamUp.Repo.Migrations.AddPhaseToGame do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :phase, :string
    end
  end
end
