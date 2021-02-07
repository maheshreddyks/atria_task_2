defmodule AtriaTask2.Repo.Migrations.Alter_Table_Event_ManagementFor_RSVP_Cancellations do
  use Ecto.Migration

  def change do
    alter table(:event_management) do
      add(:rsvp_status, :boolean)
    end
  end
end
