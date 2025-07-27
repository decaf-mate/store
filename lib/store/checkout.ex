defmodule Store.Checkout do
  alias Store.{Cart, ProductItem, Product}

  def new_cart do
    Cart.new()
  end

  def add_product(%Cart{} = cart, product, quantity) do
    with {:ok, cart} <- add_item(cart, product, quantity) do
      calculate_total(cart)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp add_item(%Cart{}, %Product{quantity: available_quantity}, requested_quantity)
       when available_quantity < requested_quantity do
    {:error,
     "Not enough quantity, #{available_quantity} available, #{requested_quantity} requested"}
  end

  defp add_item(%Cart{product_items: product_items} = cart, %Product{} = product, quantity) do
    product_item = %ProductItem{product: product, quantity: quantity}

    {:ok, %Cart{cart | product_items: [product_item | product_items]}}
  end

  defp calculate_total(%Cart{product_items: product_items} = cart) do
    total =
      product_items
      |> Enum.reduce(0, fn %ProductItem{product: %Product{price: price}, quantity: quantity},
                           acc ->
        acc + price * quantity
      end)

    %Cart{cart | total: total}
  end
end
