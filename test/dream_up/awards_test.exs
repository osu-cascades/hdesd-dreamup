defmodule DreamUp.AwardsTest do
  use DreamUp.DataCase

  alias DreamUp.Awards

  describe "awards" do
    alias DreamUp.Awards.Award

    @valid_attrs %{card_id: 42, game_id: 42, team: "some team"}
    @update_attrs %{card_id: 43, game_id: 43, team: "some updated team"}
    @invalid_attrs %{card_id: nil, game_id: nil, team: nil}

    def award_fixture(attrs \\ %{}) do
      {:ok, award} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Awards.create_award()

      award
    end

    test "list_awards/0 returns all awards" do
      award = award_fixture()
      assert Awards.list_awards() == [award]
    end

    test "get_award!/1 returns the award with given id" do
      award = award_fixture()
      assert Awards.get_award!(award.id) == award
    end

    test "create_award/1 with valid data creates a award" do
      assert {:ok, %Award{} = award} = Awards.create_award(@valid_attrs)
      assert award.card_id == 42
      assert award.game_id == 42
      assert award.team == "some team"
    end

    test "create_award/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Awards.create_award(@invalid_attrs)
    end

    test "update_award/2 with valid data updates the award" do
      award = award_fixture()
      assert {:ok, %Award{} = award} = Awards.update_award(award, @update_attrs)
      assert award.card_id == 43
      assert award.game_id == 43
      assert award.team == "some updated team"
    end

    test "update_award/2 with invalid data returns error changeset" do
      award = award_fixture()
      assert {:error, %Ecto.Changeset{}} = Awards.update_award(award, @invalid_attrs)
      assert award == Awards.get_award!(award.id)
    end

    test "delete_award/1 deletes the award" do
      award = award_fixture()
      assert {:ok, %Award{}} = Awards.delete_award(award)
      assert_raise Ecto.NoResultsError, fn -> Awards.get_award!(award.id) end
    end

    test "change_award/1 returns a award changeset" do
      award = award_fixture()
      assert %Ecto.Changeset{} = Awards.change_award(award)
    end
  end
end
