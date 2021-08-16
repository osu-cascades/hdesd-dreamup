defmodule DreamUpWeb.PageLiveTest do
  use DreamUpWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(page_live) =~ "Welcome to Phoenix!"
    Repo.insert(Card.changeset(%Card{}, %{type="Challenge", header="this is header!", prompt="prompt!"}))
  end
end
