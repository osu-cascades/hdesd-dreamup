defmodule DreamUp.Pruner do

  use GenServer

  import Ecto.Query, warn: false
  alias DreamUp.Repo

  @seconds_in_a_day 60 * 60 * 24

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_task()
    {:ok, state}
  end

  def handle_info(:prune_data, socket) do
    IO.puts("Pruning database data")
    yesterday = NaiveDateTime.add(NaiveDateTime.utc_now(), -@seconds_in_a_day)
    Repo.delete_all(from g in DreamUp.Games.Game, where: g.inserted_at < ^yesterday)
    Repo.delete_all(from p in DreamUp.Players.Player, where: p.inserted_at < ^yesterday)
    Repo.delete_all(from a in DreamUp.Awards.Award, where: a.inserted_at < ^yesterday)
    schedule_task()
    {:noreply, socket}
  end

  def schedule_task do
    Process.send_after(self(), :prune_data, 1000 * @seconds_in_a_day)
  end

end
