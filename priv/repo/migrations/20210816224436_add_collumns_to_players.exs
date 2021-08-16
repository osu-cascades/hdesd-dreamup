defmodule DreamUp.Repo.Migrations.AddCollumnsToPlayers do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :permissions, :string
      add :character, :string
    end
  end
end
