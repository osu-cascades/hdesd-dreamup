defmodule DreamUp.Repo.Migrations.AddPivotedMethodIdsToGame do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :red_pivoted_method_id, :integer
      add :blue_pivoted_method_id, :integer
    end
  end
end
