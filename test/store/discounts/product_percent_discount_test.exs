defmodule Store.Discounts.ProductPercentDiscountTest do
  use ExUnit.Case, async: true

  doctest Store.Discounts.ProductPercentDiscount

  alias Store.Discounts.ProductPercentDiscount, as: Discount
  alias Store.{ProductItem, Product}

  describe "apply/2" do
    test "applies a percent discount to a product item" do
      discount = %Discount{percentage: 10, product_id: "1"}

      product_items = [
        %ProductItem{
          product: %Product{id: "1", price: 100, name: "Apple", quantity: 1},
          quantity: 1
        }
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", price: 100, name: "Apple", quantity: 1},
                 quantity: 1,
                 discounted_price: 90
               }
             ]
    end

    test "applies a percent discount to the correct product item for multiple product items" do
      discount = %Discount{percentage: 10, product_id: "1"}

      product_items = [
        %ProductItem{
          product: %Product{id: "1", price: 100, name: "Apple", quantity: 1},
          quantity: 1
        },
        %ProductItem{
          product: %Product{id: "2", price: 200, name: "Banana", quantity: 1},
          quantity: 1
        }
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", price: 100, name: "Apple", quantity: 1},
                 quantity: 1,
                 discounted_price: 90
               },
               %ProductItem{
                 product: %Product{id: "2", price: 200, name: "Banana", quantity: 1},
                 quantity: 1,
                 discounted_price: nil
               }
             ]
    end

    test "does nothing to empty product items" do
      discount = %Discount{percentage: 10, product_id: "1"}
      product_items = []

      assert Discount.apply(discount, product_items) == []
    end
  end
end
