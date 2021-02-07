defmodule AtriaTask2Web.UserController do
  use AtriaTask2Web, :controller
  alias AtriaTask2.Models.Users
  alias AtriaTask2Web.ChangesetView

  def admin_signup(conn, params) do
    params = Map.put(params, "admin", true)

    case Users.create_user(params) do
      {:ok, changeset} ->
        response = ChangesetView.translate_ok(changeset, "Admin")

        json(conn, response)

      {:error, %Ecto.Changeset{} = changeset} ->
        response = ChangesetView.translate_errors(changeset)

        conn
        |> put_status(422)
        |> json(response)
    end
  end

  def user_signup(conn, params) do
    params = Map.put(params, "admin", false)

    case Users.create_user(params) do
      {:ok, changeset} ->
        response = ChangesetView.translate_ok(changeset, "User")

        json(conn, response)

      {:error, %Ecto.Changeset{} = changeset} ->
        response = ChangesetView.translate_errors(changeset)

        conn
        |> put_status(422)
        |> json(response)
    end
  end
end
