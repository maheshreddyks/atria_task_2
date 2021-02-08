defmodule AtriaTask2Web.UserControllerTest do
  use AtriaTask2Web.ConnCase

  setup do
    conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("accept", "application/json")

    admin = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26"
    }

    admin_fail = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26.45"
    }

    user = %{
      "email" => "mahesh@testo.in",
      "full_name" => "Mahesh Reddy",
      "password" => "123456",
      "age" => "26"
    }

    user_fail = %{
      "email" => "mahesh@testo.in",
      "full_name" => "Mahesh Reddy",
      "password" => "123456",
      "age" => "26.45"
    }

    {:ok, conn: conn, admin: admin, user: user, admin_fail: admin_fail, user_fail: user_fail}
  end

  test "Admin Signup Sucessfully", %{conn: conn, admin: admin} do
    conn = post(conn, Routes.user_path(conn, :signup, "admin", admin))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    assert result.message == "Mahesh Reddy admin signed up successfully"
  end

  test "Admin Signup Failed", %{conn: conn, admin_fail: admin_fail} do
    conn = post(conn, Routes.user_path(conn, :signup, "admin", admin_fail))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == false
  end

  test "User Signup Sucessfully", %{conn: conn, user: user} do
    conn = post(conn, Routes.user_path(conn, :signup, "v1", user))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    assert result.message == "Mahesh Reddy user signed up successfully"
  end

  test "User Signup Failed", %{conn: conn, user_fail: user_fail} do
    conn = post(conn, Routes.user_path(conn, :signup, "v1", user_fail))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == false
  end
end
