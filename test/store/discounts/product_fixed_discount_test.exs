defmodule Store.Discounts.ProductFixedDiscountTest do
  use ExUnit.Case, async: true

  doctest Store.Discounts.ProductFixedDiscount

  alias Store.Discounts.ProductFixedDiscount, as: Discount
  alias Store.{Product, ProductItem}

  import Store.Test.Fixtures

  describe "apply/2" do
    test "applies a fixed discount to a product item" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}

      product_items = [build_product_item()]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 quantity: 1,
                 discounted_price: 90,
                 original_price: 100
               }
             ]
    end

    test "does not apply a fixed discount if the product item does not have the given product_id" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        build_product_item(%{product: %{id: "2"}})
      ]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "does not apply a fixed discount if the product item does not reach the minimum quantity" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 2}

      product_items = [build_product_item()]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "applies a fixed discount to the correct product item for multiple product items" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        build_product_item(),
        build_product_item(%{product: %{id: "2", name: "Banana", price: 200}})
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 quantity: 1,
                 discounted_price: 90,
                 original_price: 100
               },
               %ProductItem{
                 product: %Product{id: "2", name: "Banana", price: 200},
                 quantity: 1,
                 discounted_price: nil,
                 original_price: 200
               }
             ]
    end

    test "does nothing to empty product items" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}
      product_items = []

      assert Discount.apply(discount, product_items) == []
    end
  end
end
