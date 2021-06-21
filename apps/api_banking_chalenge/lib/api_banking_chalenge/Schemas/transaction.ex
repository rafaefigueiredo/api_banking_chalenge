defmodule ApiBankingChalenge.Schemas.Transaction do
  @moduledoc """
  The entity of transitions

  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:value]
  @optional_params [:acc_sender_id, :acc_receiver_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "transactions" do
    field(:type, :string)
    field(:acc_sender_id, :binary_id)
    field(:acc_receiver_id, :binary_id)
    field(:value, :integer)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:type, ["transaction", "withdraw", "deposit"])
  end
end
