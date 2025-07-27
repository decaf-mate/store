defmodule Store.Discounts.ProductPercentDiscount do
  @moduledoc """
  A product percent discount. Applies a percentage discount to a product item.
  """

  alias Store.{ProductItem, Product}
  @behaviour Store.Discounts.DiscountBehaviour

  @enforce_keys [:percentage, :product_id]
  defstruct [:percentage, :product_id]

  @type t :: %__MODULE__{
          percentage: integer(),
          product_id: String.t()
        }

  @impl Store.Discounts.DiscountBehaviour
  def apply(%__MODULE__{} = discount, product_items) do
    apply_discount(discount, product_items)
  end

  defp apply_discount(%__MODULE__{percentage: percentage, product_id: product_id}, [
         %ProductItem{product: %Product{id: product_id, price: price}} = product_item | rest
       ]) do
    discounted_price = calculate_discounted_price(price, percentage)
    [%ProductItem{product_item | discounted_price: discounted_price} | rest]
  end

  defp apply_discount(_discount, [product_item | rest]) do
    [product_item | rest]
  end

  defp apply_discount(_discount, []) do
    []
  end

  defp calculate_discounted_price(price, percentage) do
    (price * (1 - percentage / 100)) |> trunc()
  end
end
