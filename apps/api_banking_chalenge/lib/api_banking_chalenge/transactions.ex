defmodule ApiBankingChalenge.Transactions do
  @moduledoc """
  Functions to make transaction on this API
  """

  require Logger

  alias ApiBankingChalenge.Repo
  alias ApiBankingChalenge.Schemas.Account
  alias ApiBankingChalenge.Schemas.Transaction

  def transaction(%{
        value: value,
        acc_sender_id: sender,
        acc_receiver_id: receiver
      }) do
    with _sender <- Ecto.UUID.cast!(sender),
         _receiver <- Ecto.UUID.cast!(receiver),
         # casting sender to get data
         acc_sender <- Repo.get!(Account, sender),
         acc_receiver <- Repo.get!(Account, receiver),
         %{valid?: true} = changeset <-
           Transaction.changeset(%{
             value: value,
             acc_sender_id: acc_sender.id,
             acc_receiver_id: acc_receiver.id,
             type: "transaction"
           }) do
      if acc_sender.balance >= value do
        update_sender_balance =
          Ecto.Changeset.change(acc_sender, balance: acc_sender.balance - value)

        update_receiver_balance =
          Ecto.Changeset.change(acc_receiver, balance: acc_receiver.balance + value)

        Repo.update(update_sender_balance)
        Repo.update(update_receiver_balance)

        Logger.info("Transfer succeded from #{acc_sender.name} to #{acc_receiver.name}")
        Repo.insert(changeset)
      else
        {:error, :not_enough_funds}
      end
    end
  rescue
    err in Ecto.CastError ->
      Logger.error(err)
      {:error, :invalid_info}

    err in Ecto.NoResultsError ->
      Logger.error(err)
      {:error, :not_found}
  end

  def withdraw(%{
        value: value,
        acc_sender_id: sender
      }) do
    with _sender <- Ecto.UUID.cast!(sender),
         # casting sender to get data
         acc_sender <- Repo.get!(Account, sender),
         %{valid?: true} = changeset <-
           Transaction.changeset(%{
             value: value,
             acc_sender_id: acc_sender.id,
             type: "withdraw"
           }) do
      if acc_sender.balance >= value do
        update_sender_balance =
          Ecto.Changeset.change(acc_sender, balance: acc_sender.balance - value)

        Repo.update(update_sender_balance)

        Logger.info("Withdraw succeded from #{acc_sender.name}")
        Repo.insert(changeset)
      else
        {:error, :not_enough_funds}
      end
    end
  rescue
    err in Ecto.CastError ->
      Logger.error(err)
      {:error, :invalid_info}

    err in Ecto.NoResultsError ->
      Logger.error(err)
      {:error, :not_found}
  end

  def deposit(%{
        value: value,
        acc_receiver_id: receiver
      }) do
    with _receiver <- Ecto.UUID.cast!(receiver),
         # casting receiver to get data
         acc_receiver <- Repo.get!(Account, receiver),
         %{valid?: true} = changeset <-
           Transaction.changeset(%{
             value: value,
             acc_receiver_id: acc_receiver.id,
             type: "deposit"
           }) do
      update_receiver_balance =
        Ecto.Changeset.change(acc_receiver, balance: acc_receiver.balance - value)

      Repo.update(update_receiver_balance)

      Logger.info("Deposit succeded to #{acc_receiver.name}")
      Repo.insert(changeset)
    end
  rescue
    err in Ecto.CastError ->
      Logger.error(err)
      {:error, :invalid_info}

    err in Ecto.NoResultsError ->
      Logger.error(err)
      {:error, :not_found}
  end
end
