# PlugShopifyEmbeddedSwitch
Should you look for the URL Params or the JWT? PlugShopifyEmbeddedSwitch tests the current `conn` and informs your app which configuration to pay attention to.

## What data does this plug create?
This plug will set three keys in the private object.

1. `conn.private[:shopify_url_config]` Shop Origin URL
2. `conn.private[:shopify_jwt_config]` JWT Object
3. `conn.private[:shop_origin_type]` will return either `:jwt` or `:url`

## Usage

1. Follow Installation instructions below
2. Add plug to your pipeline `plug PlugShopifyEmbeddedSwitch`

## Installation

The package can be installed by adding `plug_shopify_embedded_switch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_shopify_embedded_switch, "~> 0.1.0"}
  ]
end
```
