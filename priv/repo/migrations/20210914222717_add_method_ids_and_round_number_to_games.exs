defmodule DreamUp.Repo.Migrations.AddMethodIdsAndRoundNumberToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :method_1_id, :integer
      add :method_2_id, :integer
      add :method_3_id, :integer
      add :method_4_id, :integer
      add :method_5_id, :integer
      add :method_6_id, :integer
      add :method_7_id, :integer
      add :method_8_id, :integer
      add :method_9_id, :integer
      add :round_number, :integer
    end
  end
end
