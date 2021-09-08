defmodule DreamUp.Repo.Migrations.AddRoundStateToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :round_state, :string
    end
  end
end
