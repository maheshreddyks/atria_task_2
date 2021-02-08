defmodule AtriaTask2.Models.Users do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  use Ecto.Schema

  alias Bcrypt
  alias AtriaTask2.Repo

  @primary_key {:user_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :user_id}

  @type t :: %__MODULE__{}
  schema "users" do
    field(:full_name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:age, :integer)
    field(:admin, :boolean)
    timestamps()
  end

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :user_id,
      :full_name,
      :email,
      :password,
      :age,
      :admin
    ])
    |> validate_required([
      :full_name,
      :email,
      :password,
      :age,
      :admin
    ])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: hash_pwd(password))
  end

  defp put_password_hash(changeset), do: changeset
  defp hash_pwd(password), do: Bcrypt.hash_pwd_salt(password)

  @doc """

  #### Input

  ```elixir
  user = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: 26
    }

  AtriaTask2.Models.Users.create_user(user)
  ```
  #### Output

  ```elixir
  {:ok,
   %AtriaTask2.Models.Users{
     __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
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
  @spec create_user(map) :: map
  def create_user(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec find_by_username_and_password(String.t(), String.t()) :: map
  def find_by_username_and_password(email, password) do
    data = Repo.get_by(AtriaTask2.Models.Users, email: email)

    cond do
      is_map(data) ->
        {Bcrypt.verify_pass(password, data.password), data}

      true ->
        false
    end
  end
end
