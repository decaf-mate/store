defmodule Store.ProductItem do
  @moduledoc """
  A product item is a product with a quantity, it represents a product entry in a shopping cart.

  Using a product but with any storage it would be a reference to the product.
  """

  @enforce_keys [:product, :quantity]
  defstruct [:product, :quantity]

  @type t :: %__MODULE__{
          product: Store.Product.t(),
          quantity: non_neg_integer()
        }
end
