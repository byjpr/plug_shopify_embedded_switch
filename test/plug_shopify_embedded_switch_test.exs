defmodule PlugShopifyEmbeddedSwitchTest do
  use ExUnit.Case
  use Plug.Test

  @bearer "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"

  doctest PlugShopifyEmbeddedSwitch

  defp parse(conn, opts \\ []) do
    opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  defp add_authorization_header(conn) do
    conn
    |> put_req_header(
      "authorization",
      "Bearer #{@bearer}"
      )
  end

  test "URL Parameters should make :shop_origin_type :url" do
    conn =
      conn(:get, "/")
      |> Map.put(:path_params, %{"shop" => "test.myshopify.com"})
      |> parse()
      |> PlugShopifyEmbeddedSwitch.call([])

    assert conn.private[:shop_origin_type] == :url
  end

  test "Authorization headers should make :shop_origin_type :jwt" do
    conn =
      conn(:get, "/")
      |> add_authorization_header()
      |> parse()
      |> PlugShopifyEmbeddedSwitch.call([])

    assert conn.private[:shop_origin_type] == :jwt
  end

  test "Headers and URL Params both supplied should make :shop_origin_type :url" do
    conn =
      conn(:get, "/")
      |> Map.put(:path_params, %{"shop" => "test.myshopify.com"})
      |> add_authorization_header()
      |> parse()
      |> PlugShopifyEmbeddedSwitch.call([])

    assert conn.private[:shop_origin_type] == :url
  end
end
