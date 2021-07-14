defmodule DreamUp.Repo.Migrations.UpdatePlayersTable do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :game_id, :bigint
      add :team, :string
    end
  end
end
