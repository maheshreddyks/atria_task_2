defmodule AtriaTask2Web.EventController do
  use AtriaTask2Web, :controller
  alias AtriaTask2.Models.{Events, EventManagement}
  alias AtriaTask2.Utils
  alias AtriaTask2Web.ChangesetView

  plug(
    AtriaTask2.Plug.AdminAuthenticate,
    []
    when action in [
           :list_all_events,
           :admin_add_event,
           :admin_update_event,
           :admin_delete_event,
           :rsvp_count,
           :rsvp_cancelled_count
         ]
  )

  plug(
    AtriaTask2.Plug.Authenticate,
    []
    when action in [
           :list_all_user_events,
           :user_add_event,
           :user_delete_event,
           :user_filter_events,
           :event_calender
         ]
  )

  @doc """
    Lists all events for admin and for non-admins
  """
  def list_events(conn, params) do
    case params["user_type"] do
      "admin" ->
        list_all_events(conn, params)

      "v1" ->
        list_all_user_events(conn, params)
    end
  end

  @doc """
    Lists all events for admin
  """
  def list_all_events(conn, _params) do
    all_topics =
      Events.get_all_events()
      |> Utils.get_events_from_meta_deta()

    response = %{status: true, count: length(all_topics), events: all_topics}
    json(conn, response)
  end

  @doc """
    Lists all events for non_admin
  """
  def list_all_user_events(conn, _params) do
    all_topics =
      Events.get_all_events()
      |> Utils.get_events_from_meta_deta(:users)

    response = %{status: true, count: length(all_topics), events: all_topics}
    json(conn, response)
  end

  @doc """
    Add a Event by Admin
  """
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

  @doc """
    Update a Event by Admin
  """
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
              status: false,
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

  @doc """
    Delete a Event by Admin
  """
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
          {:ok, %{event: changeset}} ->
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

  @doc """
    Add RSVP status for an event to a user
  """
  def user_add_event(conn, params) do
    current_user = conn.assigns[:current_user]

    if !Utils.is_empty(params["id"]) do
      existing_data = Events.get_event(params)

      if existing_data do
        event_details = %{
          user_id: current_user.user_id,
          event_id: existing_data.id
        }

        {link_exists?, data} = EventManagement.get_event_link(event_details)

        cond do
          link_exists? ->
            if data.rsvp_status do
              response = %{
                status: false,
                message: "Event already in RSVP"
              }

              conn
              |> put_status(422)
              |> json(response)
            else
              event_details = %{
                user_id: current_user.user_id,
                event_id: existing_data.id,
                rsvp_status: true
              }

              changeset = EventManagement.changeset(data, event_details)

              if changeset.valid? do
                case EventManagement.update_event_link(changeset) do
                  {:ok, changeset} ->
                    response = ChangesetView.translate_ok(changeset, "Event User Add")
                    json(conn, response)

                  {:error, changeset} ->
                    response = ChangesetView.translate_errors(changeset)

                    conn
                    |> put_status(422)
                    |> json(response)
                end
              else
                response = ChangesetView.translate_errors(changeset)

                conn
                |> put_status(422)
                |> json(response)
              end
            end

          true ->
            event_details = %{
              user_id: current_user.user_id,
              event_id: existing_data.id,
              rsvp_status: true
            }

            case EventManagement.create_event_link(event_details) do
              {:ok, changeset} ->
                response = ChangesetView.translate_ok(changeset, "Event User Add")
                json(conn, response)

              {:error, changeset} ->
                response = ChangesetView.translate_errors(changeset)

                conn
                |> put_status(422)
                |> json(response)
            end
        end
      else
        response = %{
          status: false,
          message: "Event not available in records to accept"
        }

        conn
        |> put_status(422)
        |> json(response)
      end
    else
      response = %{
        status: false,
        message: "Event ID not sent in request"
      }

      conn
      |> put_status(422)
      |> json(response)
    end
  end

  @doc """
    Cancel RSVP status for an event to a user
  """
  def user_delete_event(conn, params) do
    current_user = conn.assigns[:current_user]

    if !Utils.is_empty(params["id"]) do
      existing_data = Events.get_event(params)

      if existing_data do
        event_details = %{
          user_id: current_user.user_id,
          event_id: existing_data.id
        }

        {link_exists?, data} = EventManagement.get_event_link(event_details)

        cond do
          link_exists? ->
            if data.rsvp_status do
              event_details = %{
                user_id: current_user.user_id,
                event_id: existing_data.id,
                rsvp_status: false
              }

              changeset = EventManagement.changeset(data, event_details)

              if changeset.valid? do
                case EventManagement.update_event_link(changeset) do
                  {:ok, changeset} ->
                    response = ChangesetView.translate_ok(changeset, "Event User Cancelled")
                    json(conn, response)

                  {:error, changeset} ->
                    response = ChangesetView.translate_errors(changeset)

                    conn
                    |> put_status(422)
                    |> json(response)
                end
              else
                response = ChangesetView.translate_errors(changeset)

                conn
                |> put_status(422)
                |> json(response)
              end
            else
              response = %{
                status: false,
                message: "Event status already in RSVP Cancelled"
              }

              conn
              |> put_status(422)
              |> json(response)
            end

          true ->
            event_details = %{
              user_id: current_user.user_id,
              event_id: existing_data.id,
              rsvp_status: false
            }

            case EventManagement.create_event_link(event_details) do
              {:ok, changeset} ->
                response = ChangesetView.translate_ok(changeset, "Event User Add")
                json(conn, response)

              {:error, changeset} ->
                response = ChangesetView.translate_errors(changeset)

                conn
                |> put_status(422)
                |> json(response)
            end
        end
      else
        response = %{
          status: false,
          message: "Event not available in records to cancel"
        }

        conn
        |> put_status(422)
        |> json(response)
      end
    else
      response = %{
        status: false,
        message: "Event ID not sent in request"
      }

      conn
      |> put_status(422)
      |> json(response)
    end
  end

  @doc """
    Confirmed / Cancelled events for a user
  """
  def user_filter_events(conn, params) do
    if !Utils.is_empty(params["event_type"]) &&
         params["event_type"] in ["confirmed", "cancelled"] do
      current_user = conn.assigns[:current_user]

      details =
        case params["event_type"] do
          "confirmed" ->
            %{user_id: current_user.user_id, rsvp_status: true}

          "cancelled" ->
            %{user_id: current_user.user_id, rsvp_status: false}
        end

      case EventManagement.get_events_link_of_user(details) do
        {false, _data} ->
          response = %{
            status: true,
            events: [],
            count: 0
          }

          conn
          |> put_status(200)
          |> json(response)

        {true, data} ->
          events = Utils.get_events_from_user_filter_events_meta_deta(data)

          response = %{status: true, count: length(events), events: events}
          json(conn, response)
      end
    else
      response = %{
        status: false,
        message: "Event Type not available. Please try confirmed/cancelled"
      }

      conn
      |> put_status(422)
      |> json(response)
    end
  end

  @doc """
    Confirmed / Cancelled events for a user
  """
  def event_calender(conn, _params) do
    current_user = conn.assigns[:current_user]

    details = %{user_id: current_user.user_id, rsvp_status: true}

    case EventManagement.get_events_link_of_user(details) do
      {false, _data} ->
        response = %{
          status: true,
          events: []
        }

        conn
        |> put_status(200)
        |> json(response)

      {true, data} ->
        events =
          Utils.get_events_from_user_filter_events_meta_deta(data)
          |> Enum.group_by(& &1.date)

        response = %{status: true, events: events}
        json(conn, response)
    end
  end

  @doc """
    RSVP Count for a admin for an event
  """
  def rsvp_count(conn, params) do
    case existing_data = Events.get_event(params) do
      nil ->
        response = %{
          status: false,
          message: "Event not available to fetch RSVP count"
        }

        conn
        |> put_status(422)
        |> json(response)

      _ ->
        details = %{event_id: existing_data.id, rsvp_status: true}

        case EventManagement.get_events_link_of_event(details) do
          {false, _data} ->
            response = %{
              status: false,
              message: "No RSVP's to show"
            }

            conn
            |> put_status(200)
            |> json(response)

          {true, data} ->
            events = Utils.get_events_for_rsvp_count(data)

            response = %{status: true, event: events}
            json(conn, response)
        end
    end
  end

  @doc """
    RSVP Cancelled Count for a admin for an event
  """
  def rsvp_cancelled_count(conn, params) do
    case existing_data = Events.get_event(params) do
      nil ->
        response = %{
          status: false,
          message: "Event not available to fetch RSVP count"
        }

        conn
        |> put_status(422)
        |> json(response)

      _ ->
        details = %{event_id: existing_data.id, rsvp_status: false}

        case EventManagement.get_events_link_of_event(details) do
          {false, _data} ->
            response = %{
              status: false,
              message: "No RSVP's to show"
            }

            conn
            |> put_status(200)
            |> json(response)

          {true, data} ->
            events = Utils.get_events_for_rsvp_count(data)

            response = %{status: true, event: events}
            json(conn, response)
        end
    end
  end
end
