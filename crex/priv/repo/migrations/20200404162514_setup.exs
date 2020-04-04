defmodule Crex.Repo.Migrations.Setup do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string, null: false)
      add(:display_name, :string)
      add(:city, :string)

      timestamps()
    end

    create table(:businesses) do
      add(:name, :string, null: false)
      add(:description, :string)
      add(:city, :string)
      add(:image_url, :string)

      timestamps()
    end

    create table(:gift_cards) do
      add(:business_id, references(:businesses, null: false))
      add(:identifier, :string, null: false)
      add(:owner_id, references(:businesses, null: false))

      timestamps()
    end

    create index(:gift_cards, :identifier, unique: true)
    create index(:gift_cards, [:business_id, :owner_id], unique: true)

    create table(:gift_card_transactions) do
      add(:gift_card_id, references(:gift_cards, null: false))
      add(:amount, :integer, null: false)
      add(:description, :string)

      timestamps()
    end

    create index(:gift_card_transactions, [:gift_card_id])
  end
end
