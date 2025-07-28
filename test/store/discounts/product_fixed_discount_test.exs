defmodule Store.Discounts.ProductFixedDiscountTest do
  use ExUnit.Case, async: true

  doctest Store.Discounts.ProductFixedDiscount

  alias Store.Discounts.ProductFixedDiscount, as: Discount
  alias Store.{ProductItem, Product}

  describe "apply/2" do
    test "applies a fixed discount to a product item" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        %ProductItem{
          product: %Product{id: "1", price: 100, name: "Apple"},
          quantity: 1
        }
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", price: 100, name: "Apple"},
                 quantity: 1,
                 discounted_price: 90
               }
             ]
    end

    test "does not apply a fixed discount if the product item does not have the given product_id" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        %ProductItem{
          product: %Product{id: "2", price: 100, name: "Apple"},
          quantity: 1
        }
      ]

      assert Discount.apply(discount, product_items) == product_items
    end

    test "does not apply a fixed discount if the product item does not reach the minimum quantity" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 2}

      product_items = [
        %ProductItem{
          product: %Product{id: "1", price: 100, name: "Apple"},
          quantity: 1
        }
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", price: 100, name: "Apple"},
                 quantity: 1,
                 discounted_price: nil
               }
             ]
    end

    test "applies a fixed discount to the correct product item for multiple product items" do
      discount = %Discount{fixed_discount: 10, product_id: "1", minimum_quantity: 1}

      product_items = [
        %ProductItem{
          product: %Product{id: "1", price: 100, name: "Apple"},
          quantity: 1
        },
        %ProductItem{
          product: %Product{id: "2", price: 200, name: "Banana"},
          quantity: 1
        }
      ]

      assert Discount.apply(discount, product_items) == [
               %ProductItem{
                 product: %Product{id: "1", price: 100, name: "Apple"},
                 quantity: 1,
                 discounted_price: 90
               },
               %ProductItem{
                 product: %Product{id: "2", price: 200, name: "Banana"},
                 quantity: 1,
                 discounted_price: nil
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
