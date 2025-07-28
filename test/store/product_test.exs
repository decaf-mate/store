defmodule Store.ProductTest do
  use ExUnit.Case, async: true

  doctest Store.Product

  @valid_params %{id: 1, name: "Apple", price: 150}
  @required_params [:id, :name, :price]

  describe "new/1" do
    test "creates a new product" do
      assert Store.Product.new(@valid_params) ==
               {:ok, %Store.Product{id: 1, name: "Apple", price: 150}}
    end

    for param <- @required_params do
      test "returns an error if the #{param} is nil" do
        params = Map.put(@valid_params, unquote(param), nil)

        assert Store.Product.new(params) == {:error, "#{unquote(param)} cannot be nil"}
      end
    end
  end
end
