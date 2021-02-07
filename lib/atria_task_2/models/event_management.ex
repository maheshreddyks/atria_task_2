defmodule AtriaTask2.Models.EventManagement do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  use Ecto.Schema

  alias AtriaTask2.Repo
  alias AtriaTask2.Models.{Users, Events}
  alias AtriaTask2.Utils
  @type t :: %__MODULE__{}
  schema "event_management" do
    belongs_to(:user, Users, references: :user_id, type: :integer)
    belongs_to(:event, Events, references: :id, type: :integer)
    field(:rsvp_status, :boolean)
    timestamps()
  end

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :event_id,
      :user_id,
      :rsvp_status
    ])
    |> validate_required([
      :event_id,
      :user_id,
      :rsvp_status
    ])
  end

  @doc """

  #### Input

  ```elixir
  user = %{
      name: "Medical Event",
      description: "medical description medical description medical description medical description",
      type: "medical",
      date: 26,
      duration: 45,
      host: "Josh",
      location: "Adams Beach"
    }

  AtriaTask2.Models.Events.create_user(user)
  ```
  #### Output

  ```elixir
  {:ok,
   %AtriaTask2.Models.Events{
     __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
     age: 26,
     email: "mahesh@test.in",
     full_name: "Mahesh Reddy",
     inserted_at: ~N[2021-02-06 12:15:31],
     password: "$2b$12$NEC0.BfL6NhKDGUrCh.l8O6WC1pkB3wDzIgfor6nHloW0a/S/0uGC",
     updated_at: ~N[2021-02-06 12:15:31],
     user_id: 1
   }}

  ```
  """
  @spec create_event_link(map) :: map
  def create_event_link(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec get_event_link(map) :: map
  def get_event_link(attrs \\ %{}) do
    data =
      Repo.get_by(AtriaTask2.Models.EventManagement,
        user_id: attrs[:user_id],
        event_id: attrs[:event_id]
      )

    IO.inspect(data)
    if data, do: {true, data}, else: {false, nil}
  end

  @spec get_events_link_of_user(map) :: map
  def get_events_link_of_user(attrs \\ %{}) do
    data =
      from(evm in AtriaTask2.Models.EventManagement,
        where: evm.user_id == ^attrs[:user_id] and evm.rsvp_status == ^attrs[:rsvp_status],
        preload: [:event]
      )
      |> Repo.all()

    if !Utils.is_empty(data), do: {true, data}, else: {false, nil}
  end

  @spec update_event_link(map) :: map
  def update_event_link(attrs) do
    Repo.update(attrs)
  end

  @spec delete_event_link(map) :: map
  def delete_event_link(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  # @spec update_event(map) :: map
  # def update_event(attrs) do
  #   Repo.update(attrs)
  # end
  #
  # @spec delete_event(map) :: map
  # def delete_event(attrs) do
  #   Repo.delete(attrs)
  # end

  # @spec get_event(map) :: map
  # def get_event(params) do
  #   Repo.get_by(AtriaTask2.Models.Events, id: params["id"])
  # end
  #
  # def get_all_events() do
  #   from(e in AtriaTask2.Models.Events,
  #     preload: [:user]
  #   )
  #   |> Repo.all()
  # end
end
