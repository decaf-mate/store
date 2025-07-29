defmodule Store.Discounts.FreeItemDiscountTest do
  use ExUnit.Case, async: true

  doctest Store.Discounts.FreeItemDiscount

  alias Store.Discounts.FreeItemDiscount, as: Discount
  alias Store.{Product, ProductItem}

  import Store.Test.Fixtures

  describe "apply/2" do
    test "applies a free item discount to a product item" do
      discount = %Discount{product_id: "1", minimum_quantity: 1}

      product_items = [build_product_item(%{quantity: 2})]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 quantity: 2,
                 original_price: 200,
                 discounted_price: 100
               }
             ]

      product_items = [build_product_item(%{quantity: 10})]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 quantity: 10,
                 original_price: 1000,
                 discounted_price: 500
               }
             ]
    end

    test "applies a free item discount to a product item with an odd quantity" do
      discount = %Discount{product_id: "1", minimum_quantity: 1}
      product_items = [build_product_item(%{quantity: 3})]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 quantity: 3,
                 original_price: 300,
                 discounted_price: 200
               }
             ]
    end

    test "does not apply a free item discount if the product item does not have the given product_id" do
      discount = %Discount{product_id: "1", minimum_quantity: 1}

      product_items = [build_product_item(%{product: %{id: "2"}})]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "does not apply a free item discount if the product item does not reach the minimum quantity" do
      discount = %Discount{product_id: "1", minimum_quantity: 2}

      product_items = [build_product_item(%{quantity: 1})]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "does not apply a free item discount if has only one product item" do
      discount = %Discount{product_id: "1", minimum_quantity: 2}

      product_items = [build_product_item()]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "applies a free item discount to the correct product item for multiple product items" do
      discount = %Discount{product_id: "1", minimum_quantity: 1}

      product_items = [
        build_product_item(%{quantity: 2}),
        build_product_item(%{product: %{id: "2", name: "Banana", price: 200}})
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", name: "Apple", price: 100},
                 discounted_price: 100,
                 original_price: 200,
                 quantity: 2
               },
               %ProductItem{
                 product: %Product{id: "2", name: "Banana", price: 200},
                 original_price: 200,
                 quantity: 1
               }
             ]
    end

    test "does nothing to empty product items" do
      discount = %Discount{product_id: "1", minimum_quantity: 1}
      product_items = []

      assert Discount.apply(discount, product_items) == []
    end
  end
end
