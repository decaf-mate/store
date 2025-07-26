defmodule Store.Cart do
  @enforce_keys [:id, :product_items, :total]
  defstruct [:id, :product_items, :total]

  @type t :: %__MODULE__{
          id: String.t(),
          product_items: list(tuple()),
          total: number()
        }

  def new() do
    %__MODULE__{id: id_generator(), product_items: [], total: 0.0}
  end

  defp id_generator() do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 5

    Enum.take_random(alphabet, length)
  end
end
