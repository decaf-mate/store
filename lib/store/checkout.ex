defmodule Store.Checkout do
  alias Store.{Cart, Context, ProductItem, Product}

  def new_cart do
    Cart.new()
  end

  @doc """
  Adds a product to the cart.
  """
  @spec add_product(Cart.t(), Context.t(), Product.t(), non_neg_integer()) :: Cart.t()
  def add_product(%Cart{} = cart, %Context{discounts: discounts}, product, quantity \\ 1) do
    cart
    |> add_item(product, quantity)
    |> apply_discounts(discounts)
    |> calculate_total()
  end

  defp add_item(%Cart{product_items: product_items} = cart, product, quantity) do
    new_product_items = Enum.reverse(add_or_update_product_item(product_items, product, quantity))

    %Cart{cart | product_items: new_product_items}
  end

  defp add_or_update_product_item(
         [%ProductItem{product: %Product{id: product_id, price: price}} = product_item | rest],
         %Product{id: product_id},
         quantity
       ) do
    new_quantity = product_item.quantity + quantity
    new_original_price = product_item.original_price + price * quantity

    [
      %ProductItem{product_item | quantity: new_quantity, original_price: new_original_price}
      | rest
    ]
  end

  defp add_or_update_product_item([product_item | rest], product, quantity) do
    [product_item | add_or_update_product_item(rest, product, quantity)]
  end

  defp add_or_update_product_item([], %Product{price: price} = product, quantity) do
    [%ProductItem{product: product, quantity: quantity, original_price: price * quantity}]
  end

  defp apply_discounts(%Cart{product_items: product_items} = cart, discounts) do
    discounted_product_items =
      discounts
      |> Enum.reduce(product_items, fn %discount_module{} = discount, acc ->
        discount_module.apply(discount, acc)
      end)
      |> Enum.reverse()

    %Cart{cart | product_items: discounted_product_items}
  end

  defp calculate_total(%Cart{product_items: product_items} = cart) do
    total =
      Enum.reduce(product_items, 0, fn
        %ProductItem{discounted_price: discounted_price}, acc when not is_nil(discounted_price) ->
          acc + discounted_price

        %ProductItem{original_price: original_price}, acc ->
          acc + original_price
      end)

    %Cart{cart | total: total}
  end
end
