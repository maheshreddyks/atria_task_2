defmodule AtriaTask2.Utils do
  @doc """
    List outs event details from the meta data as Jason Parser cant pass the original data as json.
  """
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

  @doc """
    List outs event details with  additional details from the meta data as Jason Parser cant pass the original data as json.
  """
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

  @doc """
    Sending the linked event list with additional details
  """
  def get_events_for_rsvp_count(list_of_event_links) do
    data =
      Enum.reduce(list_of_event_links, [], fn event_link, acc ->
        data = %{
          full_name: event_link.user.full_name,
          age: event_link.user.age,
          email: event_link.user.email
        }

        acc ++ [data]
      end)

    event_link = hd(list_of_event_links)
    event = event_link.event

    %{
      date: event.date,
      description: event.description,
      duration: event.duration,
      host: event.host,
      event_id: event.id,
      location: event.location,
      name: event.name,
      updated_at: event.updated_at,
      inserted_at: event.inserted_at,
      rsvp_status: event_link.rsvp_status,
      rsvp_count: data
    }
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
