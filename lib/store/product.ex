defmodule Store.Product do
  @enforce_keys [:id, :name, :price, :quantity]
  defstruct [:id, :name, :price, :quantity]

  @type t :: %__MODULE__{
          id: pos_integer(),
          name: String.t(),
          price: integer(),
          quantity: non_neg_integer()
        }

  @doc """
  Creates a new product with validation.

  ## Examples

      iex> Store.Product.new(%{id: 1, name: "Apple", price: 1.50, quantity: 10})
      {:ok, %Store.Product{id: 1, name: "Apple", price: 1.50, quantity: 10}}

      iex> Store.Product.new(%{id: nil, name: "Apple", price: 1.50, quantity: 10})
      {:error, "id cannot be nil"}
  """
  def new(%{id: id, name: name, price: price, quantity: quantity}) do
    with :ok <- validate_not_nil(id, :id),
         :ok <- validate_not_nil(name, :name),
         :ok <- validate_not_nil(price, :price),
         :ok <- validate_not_nil(quantity, :quantity) do
      {:ok,
       %__MODULE__{
         id: id,
         name: name,
         price: price,
         quantity: quantity
       }}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_not_nil(nil, field), do: {:error, "#{field} cannot be nil"}
  defp validate_not_nil(_param, _field), do: :ok
end
