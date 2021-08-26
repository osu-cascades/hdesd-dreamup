defmodule DreamUp.Repo.Migrations.AddGameAdminToPlayers do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :game_admin, :boolean
    end
  end
end
