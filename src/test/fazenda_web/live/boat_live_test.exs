defmodule FazendaWeb.BoatLiveTest do
  use FazendaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fazenda.BoatsFixtures

  @create_attrs %{image: "some image", model: "some model", price: "some price", type: "some type"}
  @update_attrs %{image: "some updated image", model: "some updated model", price: "some updated price", type: "some updated type"}
  @invalid_attrs %{image: nil, model: nil, price: nil, type: nil}

  defp create_boat(_) do
    boat = boat_fixture()
    %{boat: boat}
  end

  describe "Index" do
    setup [:create_boat]

    test "lists all boats", %{conn: conn, boat: boat} do
      {:ok, _index_live, html} = live(conn, ~p"/boats")

      assert html =~ "Listing Boats"
      assert html =~ boat.image
    end

    test "saves new boat", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/boats")

      assert index_live |> element("a", "New Boat") |> render_click() =~
               "New Boat"

      assert_patch(index_live, ~p"/boats/new")

      assert index_live
             |> form("#boat-form", boat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#boat-form", boat: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/boats")

      html = render(index_live)
      assert html =~ "Boat created successfully"
      assert html =~ "some image"
    end

    test "updates boat in listing", %{conn: conn, boat: boat} do
      {:ok, index_live, _html} = live(conn, ~p"/boats")

      assert index_live |> element("#boats-#{boat.id} a", "Edit") |> render_click() =~
               "Edit Boat"

      assert_patch(index_live, ~p"/boats/#{boat}/edit")

      assert index_live
             |> form("#boat-form", boat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#boat-form", boat: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/boats")

      html = render(index_live)
      assert html =~ "Boat updated successfully"
      assert html =~ "some updated image"
    end

    test "deletes boat in listing", %{conn: conn, boat: boat} do
      {:ok, index_live, _html} = live(conn, ~p"/boats")

      assert index_live |> element("#boats-#{boat.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#boats-#{boat.id}")
    end
  end

  describe "Show" do
    setup [:create_boat]

    test "displays boat", %{conn: conn, boat: boat} do
      {:ok, _show_live, html} = live(conn, ~p"/boats/#{boat}")

      assert html =~ "Show Boat"
      assert html =~ boat.image
    end

    test "updates boat within modal", %{conn: conn, boat: boat} do
      {:ok, show_live, _html} = live(conn, ~p"/boats/#{boat}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Boat"

      assert_patch(show_live, ~p"/boats/#{boat}/show/edit")

      assert show_live
             |> form("#boat-form", boat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#boat-form", boat: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/boats/#{boat}")

      html = render(show_live)
      assert html =~ "Boat updated successfully"
      assert html =~ "some updated image"
    end
  end
end
