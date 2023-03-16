defmodule FarmcontrolWeb.AccountsControllerTest do
  use FarmcontrolWeb.ConnCase

  import Farmcontrol.BanksFixtures

  @create_attrs %{balance: 42, number: "some number", owner: "some owner"}
  @update_attrs %{balance: 43, number: "some updated number", owner: "some updated owner"}
  @invalid_attrs %{balance: nil, number: nil, owner: nil}

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, ~p"/accounts")
      assert html_response(conn, 200) =~ "Listing Accounts"
    end
  end

  describe "new accounts" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/accounts/new")
      assert html_response(conn, 200) =~ "New Accounts"
    end
  end

  describe "create accounts" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/accounts", accounts: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/accounts/#{id}"

      conn = get(conn, ~p"/accounts/#{id}")
      assert html_response(conn, 200) =~ "Accounts #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/accounts", accounts: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Accounts"
    end
  end

  describe "edit accounts" do
    setup [:create_accounts]

    test "renders form for editing chosen accounts", %{conn: conn, accounts: accounts} do
      conn = get(conn, ~p"/accounts/#{accounts}/edit")
      assert html_response(conn, 200) =~ "Edit Accounts"
    end
  end

  describe "update accounts" do
    setup [:create_accounts]

    test "redirects when data is valid", %{conn: conn, accounts: accounts} do
      conn = put(conn, ~p"/accounts/#{accounts}", accounts: @update_attrs)
      assert redirected_to(conn) == ~p"/accounts/#{accounts}"

      conn = get(conn, ~p"/accounts/#{accounts}")
      assert html_response(conn, 200) =~ "some updated number"
    end

    test "renders errors when data is invalid", %{conn: conn, accounts: accounts} do
      conn = put(conn, ~p"/accounts/#{accounts}", accounts: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Accounts"
    end
  end

  describe "delete accounts" do
    setup [:create_accounts]

    test "deletes chosen accounts", %{conn: conn, accounts: accounts} do
      conn = delete(conn, ~p"/accounts/#{accounts}")
      assert redirected_to(conn) == ~p"/accounts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/accounts/#{accounts}")
      end
    end
  end

  defp create_accounts(_) do
    accounts = accounts_fixture()
    %{accounts: accounts}
  end
end
