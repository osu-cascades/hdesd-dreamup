defmodule DreamUp.Repo.Migrations.RenamePermissionsToTeamLeaderInPlayers do
  use Ecto.Migration

  def change do
    rename table("players"), :permissions, to: :team_leader
  end
end
