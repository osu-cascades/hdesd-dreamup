defmodule DreamUp.Repo.Migrations.AddTimeLeftToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :time_left, :time
    end
  end
end
