defmodule Pebble.Repo.Migrations.CreateTransactionTable do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:type. :string)
      add(:acc_sender_id, references(:accounts, type: :uuid))
      add(:acc_receiver_id, references(:accounts, type: :uuid))
      add(:value, :integer)

      timestamps()
    end

    create(index(:transactions, [:acc_sender_id]))
    create(index(:transactions, [:acc_receiver_id]))
  end
end
