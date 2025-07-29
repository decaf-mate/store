defmodule Store.CheckoutTest do
  defmodule FakeDiscount do
    @behaviour Store.Discounts.DiscountBehaviour
    import Kernel, except: [apply: 2]

    defstruct [:foo]

    def apply(discount, [%Store.ProductItem{product: %{id: "1"}} = product_item | product_items]) do
      [%{product_item | discounted_price: 42} | apply(discount, product_items)]
    end

    def apply(discount, [product_item | product_items]) do
      [product_item | apply(discount, product_items)]
    end

    def apply(_discount, []) do
      []
    end
  end

  defmodule AnotherFakeDiscount do
    @behaviour Store.Discounts.DiscountBehaviour
    import Kernel, except: [apply: 2]

    defstruct [:foo]

    def apply(discount, [%Store.ProductItem{product: %{id: "2"}} = product_item | product_items]) do
      [%{product_item | discounted_price: 50} | apply(discount, product_items)]
    end

    def apply(discount, [product_item | product_items]) do
      [product_item | apply(discount, product_items)]
    end

    def apply(_discount, []) do
      []
    end
  end

  use ExUnit.Case, async: true

  doctest Store.Checkout

  alias Store.Checkout
  alias Store.{Cart, Context, Product, ProductItem}

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

    test "adds the same product multiple times" do
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
             } =
               cart
               |> Checkout.add_product(context, @product)
               |> Checkout.add_product(context, @product)
    end

    test "adds multiple products" do
      cart = Checkout.new_cart()
      context = %Context{discounts: []}
      another_product = build_product(%{id: "2", name: "Banana", price: 200})

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 1
                 },
                 %ProductItem{
                   product: %Product{id: "2", name: "Banana", price: 200},
                   quantity: 1
                 }
               ],
               total: 300
             } =
               cart
               |> Checkout.add_product(context, @product)
               |> Checkout.add_product(context, another_product)
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
               |> Checkout.add_product(context, product)
               |> Checkout.add_product(context, product)
    end

    test "applies a discount to a product" do
      cart = Checkout.new_cart()

      context = %Context{
        discounts: [%__MODULE__.FakeDiscount{}]
      }

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{
                   product: %Product{id: "1", name: "Apple", price: 100},
                   quantity: 1
                 }
               ],
               total: 42
             } = Checkout.add_product(cart, context, @product)
    end

    test "applies multiple discounts to products" do
      cart = Checkout.new_cart()

      context = %Context{
        discounts: [
          %__MODULE__.FakeDiscount{},
          %__MODULE__.AnotherFakeDiscount{}
        ]
      }

      another_product = build_product(%{id: "2", name: "Banana", price: 200})

      assert %Cart{
               id: _id,
               product_items: [
                 %ProductItem{product: %Product{id: "1", name: "Apple", price: 100}, quantity: 1},
                 %ProductItem{product: %Product{id: "2", name: "Banana", price: 200}, quantity: 1}
               ],
               total: 92
             } =
               cart
               |> Checkout.add_product(context, @product)
               |> Checkout.add_product(context, another_product)
    end
  end
end
