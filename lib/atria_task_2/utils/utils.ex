defmodule AtriaTask2.Utils do
  def get_events_from_meta_deta(list_of_events) do
    Enum.reduce(list_of_events, [], fn event, acc ->
      data = %{
        event_id: event.id,
        name: event.name,
        description: event.description,
        type: event.type,
        date: event.date,
        duration: event.duration,
        location: event.location,
        created_user: event.user.full_name,
        inserted_at: event.inserted_at,
        updated_at: event.updated_at
      }

      acc ++ [data]
    end)
  end
end
