defmodule Store.Discounts.FreeItemDiscount do
  @moduledoc """
  Get a product for free if the customer buys a minimum quantity of a product.

  Required rules:
  - The product item must have the given product_id
  - The product item must have a quantity greater than or equal to the minimum quantity
  """

  alias Store.{ProductItem, Product}
  @behaviour Store.Discounts.DiscountBehaviour

  @enforce_keys [:product_id, :minimum_quantity]
  defstruct [:product_id, :minimum_quantity]

  @type t :: %__MODULE__{
          product_id: String.t(),
          minimum_quantity: non_neg_integer()
        }

  @impl Store.Discounts.DiscountBehaviour
  def apply(%__MODULE__{} = discount, product_items) do
    apply_discount(discount, product_items)
  end

  defp apply_discount(
         %__MODULE__{product_id: product_id, minimum_quantity: minimum_quantity},
         [
           %ProductItem{product: %Product{id: product_id, price: price}, quantity: quantity} =
             product_item
           | rest
         ]
       )
       when quantity > minimum_quantity do
    discounted_price = calculate_discounted_price(quantity, price)
    [%{product_item | discounted_price: discounted_price} | rest]
  end

  defp apply_discount(discount, [product_item | rest]) do
    [product_item | apply_discount(discount, rest)]
  end

  defp apply_discount(_discount, []) do
    []
  end

  defp calculate_discounted_price(quantity, price) when rem(quantity, 2) == 0 do
    div(quantity, 2) * price
  end

  defp calculate_discounted_price(quantity, price) do
    div(quantity, 2) * price + price
  end
end
