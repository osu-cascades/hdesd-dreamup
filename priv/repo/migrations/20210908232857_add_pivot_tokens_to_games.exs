defmodule DreamUp.Repo.Migrations.AddPivotTokensToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :red_pivot_token, :boolean
      add :blue_pivot_token, :boolean
    end
  end
end
