defmodule DreamUp.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :type, :string
      add :header, :string
      add :prompt, :text


      timestamps()
    end

  end

end

# delete What are some ways you can imagine to help people enjoy the food in their fridge that’s left over from previous meals?
