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
    with {:ok, cart} <- add_item(cart, product, quantity) do
      cart
      |> apply_discounts(discounts)
      |> calculate_total()
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
