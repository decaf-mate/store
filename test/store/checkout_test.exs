defmodule Store.CheckoutTest do
  use ExUnit.Case, async: true

  doctest Store.Checkout

  alias Store.Checkout
  alias Store.{Cart, Context, Product, ProductItem}
  alias Store.Discounts.ProductPercentDiscount

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
      product = %Product{id: 1, name: "Apple", price: 100, quantity: 1}
      quantity = 1

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 100, quantity: 1},
                   quantity: 1
                 }
               ],
               total: 100
             } = Checkout.add_product(cart, context, product, quantity)
    end

    test "adds product with more than one quantity" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      product = %Product{id: 1, name: "Apple", price: 100, quantity: 2}

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 100, quantity: 2},
                   quantity: 2
                 }
               ],
               total: 200
             } = Checkout.add_product(cart, context, product, 2)
    end

    test "adds multiple products" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      product1 = %Product{id: 1, name: "Apple", price: 100, quantity: 1}
      product2 = %Product{id: 2, name: "Banana", price: 200, quantity: 1}

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 2, name: "Banana", price: 200, quantity: 1},
                   quantity: 1
                 },
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 100, quantity: 1},
                   quantity: 1
                 }
               ],
               total: 300
             } =
               cart
               |> Checkout.add_product(context, product1, 1)
               |> Checkout.add_product(context, product2, 1)
    end

    # TODO: replace with a mock discount
    # TODO: add a test for multiple discounts
    test "adds product with discount" do
      cart = Checkout.new_cart()

      context = %Context{
        discounts: [%ProductPercentDiscount{percentage: 10, product_id: 1, minimum_quantity: 1}]
      }

      product = %Product{id: 1, name: "Apple", price: 100, quantity: 1}
      quantity = 1

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 100, quantity: 1},
                   quantity: 1
                 }
               ],
               total: 90
             } = Checkout.add_product(cart, context, product, quantity)
    end

    test "cannot add product with more than available quantity" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      product = %Product{id: 1, name: "Apple", price: 100, quantity: 1}
      quantity = 2

      assert {:error, "Not enough quantity, 1 available, 2 requested"} =
               Checkout.add_product(cart, context, product, quantity)
    end
  end
end
