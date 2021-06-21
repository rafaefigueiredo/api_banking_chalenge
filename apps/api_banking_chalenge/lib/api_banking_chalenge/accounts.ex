defmodule ApiBankingChalenge.Accounts do
  @moduledoc """
  Functions to change data from the accounts database
  """

  require Logger

  alias ApiBankingChalenge.Inputs.Create
  alias ApiBankingChalenge.Repo
  alias ApiBankingChalenge.Schemas.Account

  def create(params) do
    # Validating input
    with %{valid?: true, changes: changes} <- Create.changeset(params),
         # Checking if the account doesn't exist and hashing it's password.
         %{valid?: true} = unique <- Account.changeset(changes),
         # Inserting into the repository.
         {:ok, account} <- Repo.insert(unique) do
      {:ok, account}
    else
      %{valid?: false} ->
        {:error, :invalid_info}
    end
  rescue
    error in Ecto.ConstraintError ->
      case error do
        %{constraint: "accounts_cpf_index"} ->
          {:error, :cpf_conflict}

        %{constraint: "accounts_email_index"} ->
          {:error, :email_conflict}
      end
  end

  def get(account_id) do
    case Ecto.UUID.cast(account_id) do
      {:ok, _} ->
        case Repo.get(Account, account_id) do
          nil -> {:error, :not_found}
          account -> {:ok, account}
        end

      :error ->
        {:error, :invalid_info}
    end
  end

  def delete(account_id) do
    case get(account_id) do
      {:ok, account} -> Repo.delete(account)
      {:error, error} -> {:error, error}
    end
  end
end
