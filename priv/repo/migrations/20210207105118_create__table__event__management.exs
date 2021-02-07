defmodule AtriaTask2.Repo.Migrations.Create_Table_Event_Management do
  use Ecto.Migration

  def change do
    create table(:event_management) do
      add(:user_id, :integer)
      add(:event_id, :integer)

      timestamps()
    end
  end
end
