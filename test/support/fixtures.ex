defmodule Store.Test.Fixtures do
  @moduledoc """
  Test fixtures for Store domain objects.

  This module provides factory functions to create test data with sensible defaults
  while allowing attribute overrides for flexibility in tests.
  """

  alias Store.{Product, ProductItem}

  @doc """
  Creates a Product struct with default values that can be overridden.

  ## Examples

      iex> build_product()
      %Product{id: "1", name: "Apple", price: 100}

      iex> build_product(%{name: "Banana", price: 200})
      %Product{id: "1", name: "Banana", price: 200}
  """
  def build_product(overrides \\ %{}) do
    default_attrs = %{
      id: "1",
      name: "Apple",
      price: 100
    }

    attrs = Map.merge(default_attrs, overrides)

    %Product{
      id: attrs.id,
      name: attrs.name,
      price: attrs.price
    }
  end

  @doc """
  Creates a ProductItem struct with default values that can be overridden.

  ## Examples

      iex> build_product_item()
      %ProductItem{product: %Product{...}, quantity: 1, discounted_price: nil}

      iex> build_product_item(%{quantity: 2, discounted_price: 90})
      %ProductItem{product: %Product{...}, quantity: 2, discounted_price: 90}

      iex> build_product_item(%{product: %{name: "Banana", price: 200}, quantity: 3})
      %ProductItem{product: %Product{name: "Banana", price: 200, ...}, quantity: 3, ...}
  """
  def build_product_item(overrides \\ %{}) do
    {product_overrides, item_overrides} = Map.pop(overrides, :product, %{})

    product = build_product(product_overrides)
    quantity = Map.get(item_overrides, :quantity, 1)

    default_attrs = %{
      product: product,
      quantity: quantity,
      original_price: product.price * quantity,
      discounted_price: nil
    }

    attrs = Map.merge(default_attrs, item_overrides)

    %ProductItem{
      product: attrs.product,
      quantity: attrs.quantity,
      original_price: attrs.original_price,
      discounted_price: attrs.discounted_price
    }
  end
end
