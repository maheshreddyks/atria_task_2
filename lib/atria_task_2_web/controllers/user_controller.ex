defmodule AtriaTask2Web.UserController do
  use AtriaTask2Web, :controller
  alias AtriaTask2.Models.Users
  alias AtriaTask2Web.ChangesetView

  @doc """
    User/Admin Signup
  """
  def signup(conn, params) do
    if params["user_type"] in ["admin", "v1"] do
      {params, changeset_type} =
        case params["user_type"] || params[:user_type] do
          "admin" -> {Map.put(params, "admin", true), "Admin"}
          "v1" -> {Map.put(params, "admin", false), "User"}
        end

      case Users.create_user(params) do
        {:ok, changeset} ->
          response = ChangesetView.translate_ok(changeset, changeset_type)

          json(conn, response)

        {:error, %Ecto.Changeset{} = changeset} ->
          response = ChangesetView.translate_errors(changeset)

          conn
          |> put_status(422)
          |> json(response)
      end
    else
      response = %{
        status: false,
        message: "Wrong input type. Please check scope"
      }

      conn
      |> put_status(422)
      |> json(response)
    end
  end
end
