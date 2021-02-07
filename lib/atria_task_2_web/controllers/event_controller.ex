defmodule AtriaTask2Web.EventController do
  use AtriaTask2Web, :controller
  alias AtriaTask2.Models.{Events, Users}
  alias AtriaTask2.Utils
  alias AtriaTask2Web.ChangesetView
  plug(AtriaTask2.Plug.Authenticate, [:list_all_user_events, :user_add_event])

  plug(AtriaTask2.Plug.AdminAuthenticate, [
    :list_all_events,
    :admin_add_event,
    :admin_update_event,
    :admin_delete_event
  ])

  def list_events(conn, params) do
    case params["type"] do
      "admin" ->
        list_all_events(conn, params)

      "V1" ->
        list_all_user_events(conn, params)
    end
  end

  def list_all_events(conn, _params) do
    all_topics =
      Events.get_all_events()
      |> Utils.get_events_from_meta_deta()

    response = %{status: true, count: length(all_topics), events: all_topics}
    json(conn, response)
  end

  def list_all_user_events(conn, _params) do
  end

  def add_event(conn, params) do
    case params["type"] do
      "admin" ->
        admin_add_event(conn, params)

      "V1" ->
        user_add_event(conn, params)
    end
  end

  def admin_add_event(conn, params) do
    current_user = conn.assigns[:current_user]
    params = Map.put(params, "user_id", current_user.user_id)

    case Events.create_event(params) do
      {:ok, changeset} ->
        response = ChangesetView.translate_ok(changeset, "Event")

        json(conn, response)

      {:error, %Ecto.Changeset{} = changeset} ->
        response = ChangesetView.translate_errors(changeset)

        conn
        |> put_status(422)
        |> json(response)
    end
  end

  def admin_update_event(conn, params) do
    current_user = conn.assigns[:current_user]
    params = Map.put(params, "user_id", current_user.user_id)

    case existing_data = Events.get_event(params) do
      nil ->
        response = %{
          status: false,
          message: "Event name not available in records to update"
        }

        conn
        |> put_status(422)
        |> json(response)

      _ ->
        changeset = Events.changeset(existing_data, params)

        cond do
          changeset.changes == %{} ->
            response = %{
              status: true,
              message: "No Changes to update"
            }

            conn
            |> put_status(200)
            |> json(response)

          changeset.valid? ->
            case Events.update_event(changeset) do
              {:ok, changeset} ->
                response = ChangesetView.translate_ok(changeset, "Event Update")
                json(conn, response)

              {:error, changeset} ->
                response = ChangesetView.translate_errors(changeset)

                conn
                |> put_status(422)
                |> json(response)
            end

          true ->
            response = ChangesetView.translate_errors(changeset)

            conn
            |> put_status(422)
            |> json(response)
        end
    end
  end

  def admin_delete_event(conn, params) do
    current_user = conn.assigns[:current_user]
    params = Map.put(params, "user_id", current_user.user_id)

    case existing_data = Events.get_event(params) do
      nil ->
        response = %{
          status: false,
          message: "Event name not available in records to delete"
        }

        conn
        |> put_status(422)
        |> json(response)

      _ ->
        case Events.delete_event(existing_data) do
          {:ok, changeset} ->
            response = ChangesetView.translate_ok(changeset, "Event Delete")
            json(conn, response)

          {:error, changeset} ->
            response = ChangesetView.translate_errors(changeset)

            conn
            |> put_status(422)
            |> json(response)
        end
    end
  end

  def user_add_event(conn, _params) do
  end
end
