defmodule ApiBankingChalenge.Inputs.Create do
  @moduledoc """
  The entity of accounts

  """
  use Ecto.Schema

  import Ecto.Changeset

  @required_params [:name, :cpf, :email, :password]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account" do
    field(:name, :string)
    field(:cpf, :string)
    field(:email, :string)
    field(:password, :string)

    timestamps()
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 8)
    |> validate_format(:cpf, ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/)
    |> validate_format(:email, ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/)
  end
end
