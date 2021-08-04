defmodule DreamUp.Repo.Migrations.AddChallengesToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :blue_challenge_id, :bigint
      add :red_challenge_id, :bigint
    end
  end
end
