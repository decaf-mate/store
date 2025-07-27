defmodule Store.Discounts.DiscountBehaviour do
  @moduledoc """
  A discount behaviour. Receives a discount and a list of product items and returns a list of
  product items with the discount applied.
  """

  @type t :: struct()

  @callback apply(struct(), list(Store.ProductItem.t())) ::
              list(Store.ProductItem.t())
end
