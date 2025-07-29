defmodule Store.Discounts.ProductPercentDiscount do
  @moduledoc """
  Applies a percentage discount to a product item.

  Required rules:
  - The product item must have the given product_id
  - The product item must have a quantity greater than or equal to the minimum quantity
  - The percentage must be a fraction between 0 and 1
  """

  alias Store.{ProductItem, Product}
  @behaviour Store.Discounts.DiscountBehaviour

  @enforce_keys [:percentage, :product_id, :minimum_quantity]
  defstruct [:percentage, :product_id, :minimum_quantity]

  @type t :: %__MODULE__{
          percentage: float(),
          product_id: String.t(),
          minimum_quantity: non_neg_integer()
        }

  @impl Store.Discounts.DiscountBehaviour
  def apply(%__MODULE__{} = discount, product_items) do
    apply_discount(discount, product_items)
  end

  defp apply_discount(
         %__MODULE__{
           percentage: percentage,
           product_id: product_id,
           minimum_quantity: minimum_quantity
         },
         [
           %ProductItem{product: %Product{id: product_id, price: price}, quantity: quantity} =
             product_item
           | rest
         ]
       )
       when quantity >= minimum_quantity do
    discounted_price = (price * quantity * (1 - percentage)) |> trunc()
    [%ProductItem{product_item | discounted_price: discounted_price} | rest]
  end

  defp apply_discount(discount, [product_item | rest]) do
    [product_item | apply_discount(discount, rest)]
  end

  defp apply_discount(_discount, []) do
    []
  end
end
