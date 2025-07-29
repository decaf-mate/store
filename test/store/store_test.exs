defmodule Store.StoreTest do
  use ExUnit.Case, async: true

  alias Store.{Checkout, Cart, ProductItem, Product, Context}
  alias Store.Discounts.{FreeItemDiscount, ProductPercentDiscount, ProductFixedDiscount}

  import Store.Test.Fixtures

  @gr1_product build_product(%{id: "GR1", name: "Green Tea", price: 311})
  @sr1_product build_product(%{id: "SR1", name: "Strawberries", price: 200})
  @cf1_product build_product(%{id: "CF1", name: "Coffee", price: 250})

  @discounts [
    %FreeItemDiscount{product_id: "GR1", minimum_quantity: 1},
    %ProductPercentDiscount{percentage: 10, product_id: "CF1", minimum_quantity: 1},
    %ProductFixedDiscount{fixed_discount: 10, product_id: "SR1", minimum_quantity: 1}
  ]

  @context %Context{discounts: @discounts}

  describe "Kantox Store tests" do
    test "gr1, gr1 = 311" do
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
  end
end
