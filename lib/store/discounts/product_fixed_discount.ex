defmodule Store.Discounts.ProductFixedDiscount do
  @moduledoc """
  Applies a fixed discount to a product item.

  Required rules:
  - The product item must have the given product_id
  - The product item must have a quantity greater than or equal to the minimum quantity
  """

  alias Store.{ProductItem, Product}
  @behaviour Store.Discounts.DiscountBehaviour

  @enforce_keys [:fixed_discount, :product_id, :minimum_quantity]
  defstruct [:fixed_discount, :product_id, :minimum_quantity]

  @type t :: %__MODULE__{
          fixed_discount: integer(),
          product_id: String.t(),
          minimum_quantity: non_neg_integer()
        }

  @impl Store.Discounts.DiscountBehaviour
  def apply(%__MODULE__{} = discount, product_items) do
    apply_discount(discount, product_items)
  end

  defp apply_discount(
         %__MODULE__{product_id: product_id, minimum_quantity: minimum_quantity} = discount,
         [
           %ProductItem{product: %Product{id: product_id}, quantity: quantity} = product_item
           | rest
         ]
       )
       when quantity >= minimum_quantity do
    discounted_price = product_item.product.price - discount.fixed_discount
    [%{product_item | discounted_price: discounted_price} | rest]
  end

  defp apply_discount(_discount, [product_item | rest]) do
    [product_item | rest]
  end

  defp apply_discount(_discount, []) do
    []
  end
end
