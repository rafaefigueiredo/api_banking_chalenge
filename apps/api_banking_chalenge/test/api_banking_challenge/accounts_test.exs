defmodule ApiBankingChalenge.AccountsTest do
  use ApiBankingChalenge.DataCase, async: true

  alias ApiBankingChalenge.Accounts

  describe "create/1" do
    # setup do
    #   params = %{
    #     name: Ecto.UUID.generate(),
    #     email: "#{Ecto.UUID.generate()}@test.com",
    #     password: Ecto.UUID.generate(),
    #     cpf: "000.000.000-00"
    #   }
    # end

    test "create an account with correct data" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      assert {:ok, account} = Accounts.create(params)

      assert account.name == name
      assert account.email == email
      assert account.cpf == cpf
    end

    @tag capture_log: true
    test "yields error when CPF is invalid" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "invalid CPF"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      assert {:error, _} = Accounts.create(params)
    end

    @tag capture_log: true
    test "yields error when email is invalid" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      assert {:error, _} = Accounts.create(params)
    end

    @tag capture_log: true
    test "yields error when email is already taken" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@te@st.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      Accounts.create(%{
        name: name,
        email: email,
        password: password,
        cpf: "111.111.111-11"
      })

      assert {:error, :email_conflict} = Accounts.create(params)
    end

    @tag capture_log: true
    test "yields error when CPF is already taken" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@te@st.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      Accounts.create(%{
        name: name,
        email: "other@email.com",
        password: password,
        cpf: cpf
      })

      assert {:error, :cpf_conflict} = Accounts.create(params)
    end
  end

  describe "get/1" do
    test "returns the correct user if a valid id is given" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-00"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      {:ok, created} = Accounts.create(params)

      {:ok, account} = Accounts.get(created.id)

      assert account.name == name
      assert account.email == email
      assert account.cpf == cpf
    end

    test "yields error when id is invalid" do
      {:error, :invalid_info} = Accounts.get("invalid id")
    end

    test "yields error when account doesn't exist" do
      assert {:error, :not_found} = Accounts.get(Ecto.UUID.generate())
    end
  end

  describe "delete/1" do
    test "removes the correct account when input is valid" do
      name = Ecto.UUID.generate()
      email = "#{Ecto.UUID.generate()}@test.com"
      password = Ecto.UUID.generate()
      cpf = "000.000.000-11"

      params = %{
        name: name,
        email: email,
        password: password,
        cpf: cpf
      }

      {:ok, account} = Accounts.create(params)

      {:ok, deleted} = Accounts.delete(account.id)

      assert deleted.name == name
      assert deleted.email == email
      assert deleted.cpf == cpf
    end

    test "yields error when id is invalid" do
      {:error, :invalid_info} = Accounts.delete("invalid id")
    end

    test "yields error when account doesn't exist" do
      assert {:error, :not_found} = Accounts.delete(Ecto.UUID.generate())
    end
  end
end
