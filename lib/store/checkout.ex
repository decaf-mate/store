defmodule Store.Checkout do
  alias Store.{Cart, Context, ProductItem, Product}

  def new_cart do
    Cart.new()
  end

  @doc """
  Adds a product to the cart.
  """
  @spec add_product(Cart.t(), Context.t(), Product.t(), non_neg_integer()) ::
          {:ok, Cart.t()} | {:error, String.t()}
  def add_product(%Cart{} = cart, %Context{discounts: discounts}, product, quantity) do
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
         [%ProductItem{product: %Product{id: product_id}} = product_item | rest],
         %Product{id: product_id},
         quantity
       ) do
    [%{product_item | quantity: product_item.quantity + quantity} | rest]
  end

  defp add_or_update_product_item([product_item | rest], product, quantity) do
    [product_item | add_or_update_product_item(rest, product, quantity)]
  end

  defp add_or_update_product_item([], product, quantity) do
    [%ProductItem{product: product, quantity: quantity}]
  end

  defp apply_discounts(%Cart{product_items: product_items} = cart, [
         %discount_module{} = discount | rest
       ]) do
    discounted_product_items = discount_module.apply(discount, product_items)
    apply_discounts(%Cart{cart | product_items: discounted_product_items}, rest)
  end

  defp apply_discounts(cart, []) do
    cart
  end

  defp calculate_total(%Cart{product_items: product_items} = cart) do
    total =
      product_items
      |> Enum.reduce(0, fn product_item, acc ->
        acc + calculate_product_item_total(product_item)
      end)

    %Cart{cart | total: total}
  end

  defp calculate_product_item_total(%ProductItem{
         discounted_price: discounted_price,
         quantity: quantity
       })
       when not is_nil(discounted_price) do
    discounted_price * quantity
  end

  defp calculate_product_item_total(%ProductItem{
         product: %Product{price: price},
         quantity: quantity
       }) do
    price * quantity
  end
end
