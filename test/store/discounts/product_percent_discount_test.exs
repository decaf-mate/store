defmodule Store.Discounts.ProductPercentDiscountTest do
  use ExUnit.Case, async: true

  doctest Store.Discounts.ProductPercentDiscount

  alias Store.Discounts.ProductPercentDiscount, as: Discount
  alias Store.{ProductItem, Product}

  import Store.Test.Fixtures

  describe "apply/2" do
    test "applies a percent discount to a product item" do
      discount = %Discount{percentage: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        build_product_item()
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 quantity: 1,
                 original_price: 100,
                 discounted_price: 90
               }
             ]
    end

    test "does not apply a percent discount if the product item does not have the given product_id" do
      discount = %Discount{percentage: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        build_product_item(%{product: %{id: "2"}})
      ]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "does not apply a percent discount if the product item does not reach the minimum quantity" do
      discount = %Discount{percentage: 10, product_id: "1", minimum_quantity: 2}

      product_items = [build_product_item()]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "applies a percent discount to the correct product item for multiple product items" do
      discount = %Discount{percentage: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        build_product_item(),
        build_product_item(%{product: %{id: "2", name: "Banana", price: 200}})
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", price: 100, name: "Apple"},
                 quantity: 1,
                 original_price: 100,
                 discounted_price: 90
               },
               %ProductItem{
                 product: %Product{id: "2", price: 200, name: "Banana"},
                 quantity: 1,
                 original_price: 200,
                 discounted_price: nil
               }
             ]
    end

    test "does nothing to empty product items" do
      discount = %Discount{percentage: 10, product_id: "1", minimum_quantity: 1}
      product_items = []

      assert Discount.apply(discount, product_items) == []
    end
  end
end
