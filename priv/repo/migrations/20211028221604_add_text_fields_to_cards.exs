defmodule DreamUp.Repo.Migrations.AddTextFieldsToCards do
  use Ecto.Migration

  def change do
    alter table("cards") do
      add :title, :string
      add :sub_title, :string
      add :tip, :string
    end
  end
end
