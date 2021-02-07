defmodule AtriaTask2Web.UserControllerTest do
  use AtriaTask2Web.ConnCase

  setup do
    conn =
      Phoenix.ConnTest.build_conn()
      |> put_req_header("content-type", "application/json")
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  test "Admin Signup Sucessfully", %{conn: conn} do
    admin = %{
      email: "mahesh@test.in",
      full_name: "Mahesh Reddy",
      password: "123456",
      age: "26"
    }

    conn = post(conn, Routes.user_path(conn, :signup, "admin", admin))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    assert result.message == "Mahesh Reddy admin signed up successfully"
  end

  test "Admin Signup Failed", %{conn: conn} do
    admin = %{
      "email" => "mahesh@test.in",
      "full_name" => "Mahesh Reddy",
      "password" => "123456",
      "age" => "26.25",
      "type" => "admin"
    }

    conn = post(conn, Routes.user_path(conn, :signup, "admin", admin))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == false
  end

  test "User Signup Sucessfully", %{conn: conn} do
    user = %{
      "email" => "mahesh@test.in",
      "full_name" => "Mahesh Reddy",
      "password" => "123456",
      "age" => "26",
      "type" => "v1"
    }

    conn = post(conn, Routes.user_path(conn, :signup, "V1", user))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == true
    assert result.message == "Mahesh Reddy user signed up successfully"
  end

  test "User Signup Failed", %{conn: conn} do
    user = %{
      "email" => "mahesh@test.in",
      "full_name" => "Mahesh Reddy",
      "password" => "123456",
      "age" => "26.25",
      "type" => "v1"
    }

    conn = post(conn, Routes.user_path(conn, :signup, "V1", user))
    {:ok, result} = conn.resp_body |> Jason.decode(keys: :atoms)
    assert result.status == false
  end
end
