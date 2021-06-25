defmodule ApiBankingChalengeWeb.Transactions do
  @moduledoc """
  Web layer for the Transaction resource.
  """
  use ApiBankingChalengeWeb, :controller

  alias ApiBankingChalenge.Transactions

  def transaction(conn, %{
        "value" => value,
        "acc_sender_id" => sender,
        "acc_receiver_id" => receiver
      }) do
    Transactions.transaction(%{
      value: value,
      acc_sender_id: sender,
      acc_receiver_id: receiver
    })
    |> case do
      {:ok, transaction} ->
        send_json(conn, 201, "transaction.json", transaction: transaction)

      {:error, error} ->
        case error do
          :invalid_info ->
            send_json(conn, 400, "invalid_info.json")

          :not_found ->
            send_json(conn, 400, "not_found.json")

          {:missing_funds, difference} ->
            send_json(conn, 400, "insuficient_funds.json", difference: difference)
        end
    end
  end

  def withdraw(conn, %{
        "value" => value,
        "acc_sender_id" => sender
      }) do
    Transactions.withdraw(%{
      value: value,
      acc_sender_id: sender
    })
    |> case do
      {:ok, transaction} ->
        send_json(conn, 201, "transaction.json", transaction: transaction)

      {:error, error} ->
        case error do
          :invalid_info ->
            send_json(conn, 400, "invalid_info.json")

          :not_found ->
            send_json(conn, 400, "not_found.json")

          {:missing_funds, difference} ->
            send_json(conn, 400, "insuficient_funds.json", difference: difference)
        end
    end
  end

  def deposit(conn, %{
        "value" => value,
        "acc_receiver_id" => receiver
      }) do
    Transactions.transaction(%{
      value: value,
      acc_receiver_id: receiver
    })
    |> case do
      {:ok, transaction} ->
        send_json(conn, 201, "transaction.json", transaction: transaction)

      {:error, error} ->
        case error do
          :invalid_info ->
            send_json(conn, 400, "invalid_info.json")

          :not_found ->
            send_json(conn, 400, "not_found.json")
        end
    end
  end

  defp send_json(conn, status, view, opts \\ %{}) do
    conn
    |> put_status(status)
    |> render(view, opts)
  end
end
