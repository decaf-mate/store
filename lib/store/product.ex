defmodule Store.Product do
  @enforce_keys [:id, :name, :price]
  defstruct [:id, :name, :price]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          price: integer()
        }

  @doc """
  Creates a new product with validation.

  ## Examples

      iex> Store.Product.new(%{id: 1, name: "Apple", price: 1.50})
      {:ok, %Store.Product{id: 1, name: "Apple", price: 1.50}}

      iex> Store.Product.new(%{id: nil, name: "Apple", price: 1.50})
      {:error, "id cannot be nil"}
  """
  def new(%{id: id, name: name, price: price}) do
    with :ok <- validate_not_nil(id, :id),
         :ok <- validate_not_nil(name, :name),
         :ok <- validate_not_nil(price, :price) do
      {:ok, %__MODULE__{id: id, name: name, price: price}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_not_nil(nil, field), do: {:error, "#{field} cannot be nil"}
  defp validate_not_nil(_param, _field), do: :ok
end
