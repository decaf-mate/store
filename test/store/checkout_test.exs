defmodule Store.CheckoutTest do
  use ExUnit.Case, async: true

  doctest Store.Cart

  alias Store.Checkout
  alias Store.{Cart, Product, ProductItem}

  describe "new_cart/0" do
    test "creates a new shopping cart" do
      assert %Cart{
               id: _id,
               product_items: [],
               total: +0.0
             } = Checkout.new_cart()
    end
  end

  describe "add_product/3" do
    test "adds a product to the cart" do
      cart = Checkout.new_cart()
      product = %Product{id: 1, name: "Apple", price: 1.0, quantity: 1}
      quantity = 1

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 1.0, quantity: 1},
                   quantity: 1
                 }
               ],
               total: 1.0
             } = Checkout.add_product(cart, product, quantity)
    end

    test "adds product with more than one quantity" do
      cart = Checkout.new_cart()
      product = %Product{id: 1, name: "Apple", price: 1.0, quantity: 2}

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 1.0, quantity: 2},
                   quantity: 2
                 }
               ],
               total: 2.0
             } = Checkout.add_product(cart, product, 2)
    end

    test "adds multiple products" do
      cart = Checkout.new_cart()
      product1 = %Product{id: 1, name: "Apple", price: 1.0, quantity: 1}
      product2 = %Product{id: 2, name: "Banana", price: 2.0, quantity: 1}

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: 2, name: "Banana", price: 2.0, quantity: 1},
                   quantity: 1
                 },
                 %ProductItem{
                   product: %Product{id: 1, name: "Apple", price: 1.0, quantity: 1},
                   quantity: 1
                 }
               ],
               total: 3.0
             } =
               Checkout.add_product(cart, product1, 1)
               |> Checkout.add_product(product2, 1)
    end

    test "cannot add product with more than available quantity" do
      cart = Checkout.new_cart()
      product = %Product{id: 1, name: "Apple", price: 1.0, quantity: 1}
      quantity = 2

      assert {:error, "Not enough quantity, 1 available, 2 requested"} =
               Checkout.add_product(cart, product, quantity)
    end
  end
end
