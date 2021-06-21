defmodule ApiBankingChalenge.Schemas.Account do
  @moduledoc """
  The entity of accounts

  """
  use Ecto.Schema

  import Ecto.Changeset

  @possible_params [:name, :cpf, :email, :password]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field(:name, :string)
    field(:cpf, :string)
    field(:email, :string)
    field(:balance, :integer)
    field(:password, :string, virtual: true)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @possible_params)
  end
end
