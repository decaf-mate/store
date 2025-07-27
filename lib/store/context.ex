defmodule Store.Context do
  @moduledoc """
  A context for the store application.
  """

  @enforce_keys [:discounts]
  defstruct [:discounts]

  @type t :: %__MODULE__{
          discounts: list(Store.Discounts.DiscountBehaviour.t())
        }
end
