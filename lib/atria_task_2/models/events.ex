defmodule AtriaTask2.Models.Events do
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Ecto.Multi

  use Ecto.Schema

  alias AtriaTask2.Repo
  alias AtriaTask2.Models.{Users, EventManagement}
  @type t :: %__MODULE__{}
  schema "events" do
    field(:name, :string)
    field(:description, :string)
    field(:type, :string)
    field(:date, :date)
    field(:duration, :string)
    field(:host, :string)
    field(:location, :string)
    belongs_to(:user, Users, references: :user_id, type: :integer)

    timestamps()
  end

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :name,
      :description,
      :type,
      :date,
      :duration,
      :host,
      :location,
      :user_id
    ])
    |> validate_required([
      :name,
      :description,
      :type,
      :date,
      :duration,
      :host,
      :location,
      :user_id
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
  @spec create_event(map) :: map
  def create_event(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec update_event(map) :: map
  def update_event(attrs) do
    Repo.update(attrs)
  end

  @spec delete_event(map) :: map
  def delete_event(attrs) do
    query = from(evm in EventManagement, where: evm.event_id == ^attrs.id)

    Multi.new()
    |> Multi.delete(:event, attrs)
    |> Multi.delete_all(:event_management, query)
    |> Repo.transaction()
  end

  @spec get_event(map) :: map
  def get_event(params) do
    Repo.get_by(AtriaTask2.Models.Events, id: params["id"])
  end

  def get_all_events() do
    from(e in AtriaTask2.Models.Events,
      preload: [:user]
    )
    |> Repo.all()
  end
end
