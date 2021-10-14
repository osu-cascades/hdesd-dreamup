defmodule DreamUp.Repo.Migrations.CreateAwards do
  use Ecto.Migration

  def change do
    create table(:awards) do
      add :game_id, :integer
      add :team, :string
      add :card_id, :integer

      timestamps()
    end

  end
end
