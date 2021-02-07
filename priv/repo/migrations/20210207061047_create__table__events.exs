defmodule AtriaTask2.Repo.Migrations.Create_Table_Events do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:name, :string)
      add(:description, :text)
      add(:type, :string)
      add(:date, :date)
      add(:duration, :string)
      add(:host, :string)
      add(:location, :text)
      add(:user_id, :integer)

      timestamps()
    end
  end
end
