defmodule PlugShopifyEmbeddedSwitch do
  @moduledoc """
  Switches auth between URL Params and JWT, designed for Shopify App Bridge. Add the plug to any pipeline
  where you would like to do both URL param and JWT auth.

  ```elixir
  pipeline :demo do
    plug PlugShopifyEmbeddedSwitch
  end
  ```

  This plug will set three keys in the private object which you can use in follow up plugs.

  1. `conn.private[:shopify_url_config]` Shop Origin URL
  2. `conn.private[:shopify_jwt_config]` JWT Object
  3. `conn.private[:shop_origin_type]` will return either `:jwt` or `:url`

  """
  import Plug.Conn

  @spec init(any) :: any
  def init(options), do: options

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _) do
    origin_url_params = PlugShopifyEmbeddedSwitch.Helper.get_param_from_url(conn, :shop)

    if origin_url_params do
      conn
      |> put_private(:shopify_url_config, origin_url_params)
      |> put_private(:shop_origin_type, :url)
    else
      origin_header_params =
        PlugShopifyEmbeddedSwitch.Helper.get_param_from_header(conn, "authorization")

      conn
      |> put_private(:shopify_jwt_config, origin_header_params)
      |> put_private(:shop_origin_type, :jwt)
    end
  end
end
