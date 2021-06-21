defmodule ApiBankingChalenge.TransactionsTest do
  use ApiBankingChalenge.DataCase, async: true

  alias ApiBankingChalenge.Accounts
  alias ApiBankingChalenge.Transactions

  describe "transaction/1" do
    test "succeeds if money was sent" do
      value = Enum.random(100..100_000)

      sender_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      receiver_info = %{
        name: "Felix",
        email: "gatofelix@test.com",
        password: "12345678",
        cpf: "666.456.789-10"
      }

      {:ok, sender} = Accounts.create(sender_info)
      {:ok, receiver} = Accounts.create(receiver_info)

      {:ok, transaction} =
        Transactions.transaction(%{
          value: value,
          acc_sender_id: sender.id,
          acc_receiver_id: receiver.id
        })

      assert transaction.acc_sender_id == sender.id
      assert transaction.acc_receiver_id == receiver.id
      assert transaction.value == value
    end

    test "fails when sender has insuficient funds" do
      value = 100_100

      sender_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      receiver_info = %{
        name: "Felix",
        email: "gatofelix@test.com",
        password: "12345678",
        cpf: "666.456.789-10"
      }

      {:ok, sender} = Accounts.create(sender_info)

      {:ok, receiver} = Accounts.create(receiver_info)

      assert {:error, :not_enough_funds} =
               Transactions.transaction(%{
                 value: value,
                 acc_sender_id: sender.id,
                 acc_receiver_id: receiver.id
               })
    end

    test "fails when an account id is invalid" do
      value = 100

      sender_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      {:ok, sender} = Accounts.create(sender_info)

      assert {:error, :invalid_info} =
               Transactions.transaction(%{
                 value: value,
                 acc_sender_id: sender.id,
                 acc_receiver_id: "invalid id"
               })
    end

    test "fails when an account is not found" do
      value = 100

      sender_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      {:ok, sender} = Accounts.create(sender_info)

      # IO.inspect(sender)

      assert {:error, :not_found} =
               Transactions.transaction(%{
                 value: value,
                 acc_sender_id: sender.id,
                 acc_receiver_id: Ecto.UUID.generate()
               })
    end
  end

  describe "withdraw/1" do
    test "succeeds if money was withdrawn" do
      value = Enum.random(100..100_000)

      sender_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      {:ok, sender} = Accounts.create(sender_info)

      {:ok, withdraw} =
        Transactions.withdraw(%{
          value: value,
          acc_sender_id: sender.id
        })

      assert withdraw.acc_sender_id == sender.id
      assert withdraw.value == value
    end

    test "fails when sender has insuficient funds" do
      value = 100_100

      sender_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      {:ok, sender} = Accounts.create(sender_info)

      assert {:error, :not_enough_funds} =
               Transactions.withdraw(%{
                 value: value,
                 acc_sender_id: sender.id
               })
    end

    test "fails when an account id is invalid" do
      value = 100

      assert {:error, :invalid_info} =
               Transactions.withdraw(%{
                 value: value,
                 acc_sender_id: "invalid id"
               })
    end

    test "fails when an account is not found" do
      value = 100

      assert {:error, :not_found} =
               Transactions.withdraw(%{
                 value: value,
                 acc_sender_id: Ecto.UUID.generate()
               })
    end
  end

  describe "deposit/1" do
    test "succeeds if money was deposited" do
      value = Enum.random(100..100_000)

      receiver_info = %{
        name: "Rafael",
        email: "rafael@test.com",
        password: "12345678",
        cpf: "123.456.789-10"
      }

      {:ok, receiver} = Accounts.create(receiver_info)

      {:ok, deposit} =
        Transactions.deposit(%{
          value: value,
          acc_receiver_id: receiver.id
        })

      assert deposit.acc_receiver_id == receiver.id
      assert deposit.value == value
    end

    test "fails when an receiver id is invalid" do
      value = 100

      assert {:error, :invalid_info} =
               Transactions.deposit(%{
                 value: value,
                 acc_receiver_id: "invalid id"
               })
    end

    test "fails when an a receiver is not found" do
      value = 100

      assert {:error, :not_found} =
               Transactions.deposit(%{
                 value: value,
                 acc_receiver_id: Ecto.UUID.generate()
               })
    end
  end
end
