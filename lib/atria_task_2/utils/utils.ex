defmodule AtriaTask2.Utils do
  def get_events_from_meta_deta(list_of_events, type \\ :default) do
    Enum.reduce(list_of_events, [], fn event, acc ->
      data = %{
        event_id: event.id,
        name: event.name,
        description: event.description,
        type: event.type,
        date: event.date,
        duration: event.duration,
        location: event.location,
        inserted_at: event.inserted_at,
        updated_at: event.updated_at
      }

      if type == :users, do: Map.put(data, :created_user, event.user.full_name), else: data
      acc ++ [data]
    end)
  end

  def get_events_from_user_filter_events_meta_deta(list_of_events) do
    Enum.reduce(list_of_events, [], fn event, acc ->
      data = %{
        event_id: event.event.id,
        name: event.event.name,
        description: event.event.description,
        type: event.event.type,
        date: event.event.date,
        duration: event.event.duration,
        location: event.event.location,
        inserted_at: event.event.inserted_at,
        updated_at: event.event.updated_at,
        rsvp_status: event.rsvp_status
      }

      acc ++ [data]
    end)
  end

  # ------------------------------------------------------------------

  @doc """
  Returns `true` if the `val` is empty; otherwise returns `false`

  ### Examples

      iex> Helper.is_empty(%{})
      true

      iex> Helper.is_empty(nil)
      true

      iex> Helper.is_empty([])
      true

      iex> Helper.is_empty("  ")
      true

      iex> Helper.is_empty("s")
      false
  """
  def is_empty(val) when is_nil(val) do
    true
  end

  def is_empty(val) when is_binary(val) do
    val = String.trim(val)
    byte_size(val) == 0
  end

  def is_empty(val) when is_list(val) do
    Enum.empty?(val)
  end

  def is_empty(val) when is_map(val) do
    map_size(val) == 0
  end

  def is_empty(val) when is_tuple(val) do
    tuple_size(val) == 0
  end

  def is_empty(_val) do
    false
  end
end
