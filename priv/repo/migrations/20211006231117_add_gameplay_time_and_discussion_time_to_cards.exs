defmodule DreamUp.Repo.Migrations.AddGameplayTimeAndDiscussionTimeToCards do
  use Ecto.Migration

  def change do
    alter table("cards") do
      add :gameplay_time, :time
      add :discussion_time, :time
    end
  end
end
