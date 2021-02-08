defmodule AtriaTask2Web.EventControllerTest do
  use AtriaTask2Web.ConnCase

  setup do
    conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("accept", "application/json")

    admin_conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Basic bWFoZXNoQHRlc3QuaW46MTIzNDU2")
      |> put_req_header("accept", "application/json")

    user_1_conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Basic bWFoZXNoQHRlc3RvLmluOjEyMzQ1Ng==")
      |> put_req_header("accept", "application/json")

    user_2_conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Basic bWFoZXNoQHRlc3R4LmluOjEyMzQ1Ng==")
      |> put_req_header("accept", "application/json")

    admin = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26"
    }

    user_1 = %{
      email: "mahesh@testo.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26"
    }

    user_2 = %{
      email: "mahesh@testx.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26"
    }

    event_1 = %{
      "date" => "2021-11-20",
      "description" =>
        "medical description medical description medical description medical description",
      "duration" => "45",
      "host" => "Josh",
      "location" => "Adams Beach",
      "name" => "Medical Event 1",
      "type" => "medical"
    }

    event_2 = %{
      "date" => "2021-10-20",
      "description" =>
        "medical description medical description medical description medical description",
      "duration" => "45",
      "host" => "Josh",
      "location" => "Adams Beach",
      "name" => "Medical Event 3",
      "type" => "medical"
    }

    {:ok,
     admin_conn: admin_conn,
     conn: conn,
     user_1_conn: user_1_conn,
     user_2_conn: user_2_conn,
     admin: admin,
     user_1: user_1,
     user_2: user_2,
     event_1: event_1,
     event_2: event_2}
  end

  test "Admin Events CRUD Operations", %{admin_conn: admin_conn, admin: admin, event_1: event_1} do
    _conn_res_1 = post(admin_conn, Routes.user_path(admin_conn, :signup, "admin", admin))

    update_params = %{
      "date" => "2020-11-20",
      "description" =>
        "medical description medical description medical description medical description",
      "duration" => "60",
      "host" => "Josh",
      "location" => "Adams Beach",
      "name" => "Medical Event 3"
    }

    ## Add Event
    conn_res_1 =
      post(admin_conn, Routes.event_path(admin_conn, :admin_add_event, "admin", event_1))

    {:ok, result} = conn_res_1.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    ## List Event
    conn_res_2 = get(admin_conn, Routes.event_path(admin_conn, :list_events, "admin"))
    {:ok, result} = conn_res_2.resp_body |> Jason.decode(keys: :atoms)
    event = hd(result[:events])
    assert result.status == true
    ## Update Event
    conn_res_3 =
      post(
        admin_conn,
        Routes.event_path(admin_conn, :admin_update_event, event.event_id, update_params)
      )

    {:ok, result} = conn_res_3.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    ## Delete Event
    conn_res_4 =
      delete(admin_conn, Routes.event_path(admin_conn, :admin_delete_event, event.event_id))

    {:ok, result} = conn_res_4.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
  end

  test "Agent Events CRUD Operations", %{
    admin_conn: admin_conn,
    conn: conn,
    user_1_conn: user_1_conn,
    user_2_conn: user_2_conn,
    admin: admin,
    user_1: user_1,
    user_2: user_2,
    event_1: event_1,
    event_2: event_2
  } do
    _conn = post(conn, Routes.user_path(conn, :signup, "admin", admin))
    _conn = post(conn, Routes.user_path(conn, :signup, "v1", user_1))
    _conn = post(conn, Routes.user_path(conn, :signup, "v1", user_2))

    ## Add Event by Admin
    _conn = post(admin_conn, Routes.event_path(admin_conn, :admin_add_event, "admin", event_1))
    _conn = post(admin_conn, Routes.event_path(admin_conn, :admin_add_event, "admin", event_2))

    ## List All Events for User
    conn_res_2 = get(user_1_conn, Routes.event_path(user_1_conn, :list_events, "v1"))
    {:ok, result} = conn_res_2.resp_body |> Jason.decode(keys: :atoms)
    [event_1, event_2] = result[:events]
    assert result.status == true
    assert result.count == 2

    ## User Add Event/ Accept RSVP
    conn_res_3_1 =
      post(user_1_conn, Routes.event_path(user_1_conn, :user_add_event, "v1", event_1.event_id))

    conn_res_3_2 =
      post(user_1_conn, Routes.event_path(user_1_conn, :user_add_event, "v1", event_2.event_id))

    conn_res_3_3 =
      post(user_2_conn, Routes.event_path(user_2_conn, :user_add_event, "v1", event_1.event_id))

    conn_res_3_4 =
      post(user_2_conn, Routes.event_path(user_2_conn, :user_add_event, "v1", event_2.event_id))

    {:ok, result_3_1} = conn_res_3_1.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_3_2} = conn_res_3_2.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_3_3} = conn_res_3_3.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_3_4} = conn_res_3_4.resp_body |> Jason.decode(keys: :atoms)
    assert result_3_1.status == true
    assert result_3_1.message == "RSVP for event created successfully"
    assert result_3_2.status == true
    assert result_3_2.message == "RSVP for event created successfully"
    assert result_3_3.status == true
    assert result_3_3.message == "RSVP for event created successfully"
    assert result_3_4.status == true
    assert result_3_4.message == "RSVP for event created successfully"

    ## User Delete Event/ Cancel RSVP
    conn_res_4_1 =
      delete(
        user_1_conn,
        Routes.event_path(user_1_conn, :user_delete_event, event_1.event_id)
      )

    conn_res_4_2 =
      delete(
        user_2_conn,
        Routes.event_path(user_1_conn, :user_delete_event, event_2.event_id)
      )

    {:ok, result_4_1} = conn_res_4_1.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_4_2} = conn_res_4_2.resp_body |> Jason.decode(keys: :atoms)
    assert result_4_1.status == true
    assert result_4_1.message == "RSVP for event cancelled successfully"
    assert result_4_2.status == true
    assert result_4_2.message == "RSVP for event cancelled successfully"

    ## User Confirmed RSVP Event List
    conn_res_5_1 =
      get(
        user_1_conn,
        Routes.event_path(user_1_conn, :user_filter_events, "v1", "confirmed")
      )

    conn_res_5_2 =
      get(
        user_2_conn,
        Routes.event_path(user_2_conn, :user_filter_events, "v1", "confirmed")
      )

    conn_res_5_3 =
      get(
        user_1_conn,
        Routes.event_path(user_1_conn, :user_filter_events, "v1", "cancelled")
      )

    conn_res_5_4 =
      get(
        user_2_conn,
        Routes.event_path(user_2_conn, :user_filter_events, "v1", "cancelled")
      )

    {:ok, result_5_1} = conn_res_5_1.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_5_2} = conn_res_5_2.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_5_3} = conn_res_5_3.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_5_4} = conn_res_5_4.resp_body |> Jason.decode(keys: :atoms)
    assert result_5_1.status == true
    assert result_5_2.status == true
    assert result_5_3.status == true
    assert result_5_4.status == true
    assert result_5_1.count == 1
    assert result_5_2.count == 1
    assert result_5_3.count == 1
    assert result_5_4.count == 1

    ## Event Calender
    conn_res_6_1 = get(user_1_conn, Routes.event_path(user_1_conn, :event_calender, "v1"))
    conn_res_6_2 = get(user_2_conn, Routes.event_path(user_2_conn, :event_calender, "v1"))
    {:ok, result_6_1} = conn_res_6_1.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_6_2} = conn_res_6_2.resp_body |> Jason.decode(keys: :atoms)
    assert result_6_1.status == true
    assert result_6_2.status == true

    ## Admin RSVP Count
    conn_res_7_1 =
      get(admin_conn, Routes.event_path(admin_conn, :rsvp_count, "v1", event_1.event_id))

    conn_res_7_2 =
      get(admin_conn, Routes.event_path(admin_conn, :rsvp_count, "v1", event_2.event_id))

    {:ok, result_7_1} = conn_res_7_1.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_7_2} = conn_res_7_2.resp_body |> Jason.decode(keys: :atoms)
    assert result_7_1.status == true
    assert result_7_2.status == true
    assert length(result_7_1.event.rsvp_count) == 1
    assert length(result_7_2.event.rsvp_count) == 1

    ## Admin RSVP cancelled Count
    conn_res_8_1 =
      get(
        admin_conn,
        Routes.event_path(admin_conn, :rsvp_cancelled_count, "v1", event_1.event_id)
      )

    conn_res_8_2 =
      get(
        admin_conn,
        Routes.event_path(admin_conn, :rsvp_cancelled_count, "v1", event_2.event_id)
      )

    {:ok, result_8_1} = conn_res_8_1.resp_body |> Jason.decode(keys: :atoms)
    {:ok, result_8_2} = conn_res_8_2.resp_body |> Jason.decode(keys: :atoms)
    assert result_8_1.status == true
    assert result_8_2.status == true
    assert length(result_8_1.event.rsvp_count) == 1
    assert length(result_8_2.event.rsvp_count) == 1
  end
end
