defmodule AtriaTask2Web.EventControllerTest do
  use AtriaTask2Web.ConnCase

  setup do
    conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Basic bWFoZXNoQHRlc3QuaW46MTIzNDU2")
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  test "Admin Events CRUD Operations", %{conn: conn} do
    admin = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26"
    }

    _conn_res_1 = post(conn, Routes.user_path(conn, :signup, "admin", admin))

    params = %{
      "date" => "2020-11-20",
      "description" =>
        "medical description medical description medical description medical description",
      "duration" => "45",
      "host" => "Josh",
      "location" => "Adams Beach",
      "name" => "Medical Event 3"
    }

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
    conn_res_1 = post(conn, Routes.event_path(conn, :add_event, "admin", params))
    {:ok, result} = conn_res_1.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    ## List Event
    conn_res_2 = get(conn, Routes.event_path(conn, :list_events, "admin"))
    {:ok, result} = conn_res_2.resp_body |> Jason.decode(keys: :atoms)
    event = hd(result[:events])
    assert result.status == true
    ## Update Event
    conn_res_3 =
      post(conn, Routes.event_path(conn, :admin_update_event, event.event_id, update_params))

    {:ok, result} = conn_res_3.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true

    ## Delete Event
    conn_res_4 = delete(conn, Routes.event_path(conn, :admin_delete_event, event.event_id))
    {:ok, result} = conn_res_4.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
  end
end
