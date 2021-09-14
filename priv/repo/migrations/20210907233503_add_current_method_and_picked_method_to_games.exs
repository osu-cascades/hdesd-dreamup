defmodule DreamUp.Repo.Migrations.AddCurrentMethodAndPickedMethodToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :current_method, :string
      add :picked_method_id, :integer
    end
  end
end
