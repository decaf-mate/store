defmodule Store.StoreTest do
  use ExUnit.Case, async: true

  alias Store.{Checkout, Cart, ProductItem, Product, Context}
  alias Store.Discounts.{FreeItemDiscount, ProductPercentDiscount, ProductFixedDiscount}

  import Store.Test.Fixtures

  @gr1_product build_product(%{id: "GR1", name: "Green Tea", price: 311})
  @sr1_product build_product(%{id: "SR1", name: "Strawberries", price: 500})
  @cf1_product build_product(%{id: "CF1", name: "Coffee", price: 1123})

  @discounts [
    %FreeItemDiscount{product_id: "GR1", minimum_quantity: 1},
    %ProductPercentDiscount{percentage: 1 / 3, product_id: "CF1", minimum_quantity: 3},
    %ProductFixedDiscount{fixed_discount: 50, product_id: "SR1", minimum_quantity: 3}
  ]

  @context %Context{discounts: @discounts}

  describe "Kantox Store tests" do
    test "GR1, SR1, GC1, GR1, CF1 = 2245" do
      cart = Checkout.new_cart()

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "GR1", name: "Green Tea", price: 311},
                   quantity: 3,
                   discounted_price: 622
                 },
                 %ProductItem{
                   product: %Product{id: "SR1", name: "Strawberries", price: 500},
                   quantity: 1,
                   discounted_price: nil
                 },
                 %ProductItem{
                   product: %Product{id: "CF1", name: "Coffee", price: 1123},
                   quantity: 1,
                   discounted_price: nil
                 }
               ],
               total: 2245
             } =
               cart
               |> Checkout.add_product(@context, @gr1_product)
               |> Checkout.add_product(@context, @sr1_product)
               |> Checkout.add_product(@context, @gr1_product)
               |> Checkout.add_product(@context, @gr1_product)
               |> Checkout.add_product(@context, @cf1_product)
    end

    test "GR1, GR1 = 311" do
      cart = Checkout.new_cart()

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "GR1", name: "Green Tea", price: 311},
                   quantity: 2,
                   discounted_price: 311
                 }
               ],
               total: 311
             } =
               cart
               |> Checkout.add_product(@context, @gr1_product)
               |> Checkout.add_product(@context, @gr1_product)
    end

    test "SR1, SR1, GR1, SR1 = 1661" do
      cart = Checkout.new_cart()

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "SR1", name: "Strawberries", price: 500},
                   quantity: 3,
                   discounted_price: 1350
                 },
                 %ProductItem{
                   product: %Product{id: "GR1", name: "Green Tea", price: 311},
                   quantity: 1,
                   discounted_price: nil
                 }
               ],
               total: 1661
             } =
               cart
               |> Checkout.add_product(@context, @sr1_product)
               |> Checkout.add_product(@context, @sr1_product)
               |> Checkout.add_product(@context, @gr1_product)
               |> Checkout.add_product(@context, @sr1_product)
    end

    test "GR1, CF1, SR1, CF1, CF1 = 3057" do
      cart = Checkout.new_cart()

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "GR1", name: "Green Tea", price: 311},
                   quantity: 1,
                   discounted_price: nil
                 },
                 %ProductItem{
                   product: %Product{id: "CF1", name: "Coffee", price: 1123},
                   quantity: 3,
                   discounted_price: 2246
                 },
                 %ProductItem{
                   product: %Product{id: "SR1", name: "Strawberries", price: 500},
                   quantity: 1,
                   discounted_price: nil
                 }
               ],
               total: 3057
             } =
               cart
               |> Checkout.add_product(@context, @gr1_product)
               |> Checkout.add_product(@context, @cf1_product)
               |> Checkout.add_product(@context, @sr1_product)
               |> Checkout.add_product(@context, @cf1_product)
               |> Checkout.add_product(@context, @cf1_product)
    end
  end
end
