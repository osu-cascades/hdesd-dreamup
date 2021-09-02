defmodule DreamUp.Repo.Migrations.AddTimeTokensToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :red_add_time_token, :boolean
      add :blue_add_time_token, :boolean
    end
  end
end
