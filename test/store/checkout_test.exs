defmodule Store.CheckoutTest do
  use ExUnit.Case, async: true

  doctest Store.Checkout

  alias Store.Checkout
  alias Store.{Cart, Context, Product, ProductItem}
  alias Store.Discounts.ProductPercentDiscount

  import Store.Test.Fixtures

  @product build_product()

  describe "new_cart/0" do
    test "creates a new shopping cart" do
      assert %Cart{
               id: _id,
               product_items: [],
               total: 0
             } = Checkout.new_cart()
    end
  end

  describe "add_product/3" do
    test "adds a product to the cart" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      quantity = 1

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 1
                 }
               ],
               total: 100
             } = Checkout.add_product(cart, context, @product, quantity)
    end

    test "adds product with more than one quantity" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 2
                 }
               ],
               total: 200
             } = Checkout.add_product(cart, context, @product, 2)
    end

    test "adds multiple products" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      another_product = build_product(%{id: "2", name: "Banana", price: 200})

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "2", name: "Banana", price: 200},
                   quantity: 1
                 },
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 1
                 }
               ],
               total: 300
             } =
               cart
               |> Checkout.add_product(context, @product, 1)
               |> Checkout.add_product(context, another_product, 1)
    end

    test "adds multiple same product_id multiple times" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      product = build_product(%{id: "1", name: "Apple", price: 100})

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 2
                 }
               ],
               total: 200
             } =
               cart
               |> Checkout.add_product(context, product, 1)
               |> Checkout.add_product(context, product, 1)
    end

    # TODO: replace with a mock discount
    # TODO: add a test for multiple discounts
    test "adds product with discount" do
      cart = Checkout.new_cart()

      context = %Context{
        discounts: [%ProductPercentDiscount{percentage: 10, product_id: "1", minimum_quantity: 1}]
      }

      quantity = 1

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 1
                 }
               ],
               total: 90
             } = Checkout.add_product(cart, context, @product, quantity)
    end
  end
end
