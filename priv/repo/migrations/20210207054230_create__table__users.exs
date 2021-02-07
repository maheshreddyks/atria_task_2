defmodule AtriaTask2.Repo.Migrations.Create_Table_Users do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:user_id, :serial, primary_key: true)
      add(:full_name, :string)
      add(:email, :string)
      add(:password, :string)
      add(:age, :integer)
      add(:admin, :boolean)

      timestamps()
    end

    create(index("users", [:user_id, :password]))
    create(index("users", [:user_id, :full_name, :email, :age, :admin]))
    create unique_index(:users, [:email])
  end
end
