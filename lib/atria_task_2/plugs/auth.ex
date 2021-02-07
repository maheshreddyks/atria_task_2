defmodule AtriaTask2.Plug.Authenticate do
  @moduledoc false

  import Plug.Conn
  use AtriaTask2Web, :controller

  def init(default), do: default

  def call(conn, _reason) do
    {user, pass} = Plug.BasicAuth.parse_basic_auth(conn)

    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         {true, %AtriaTask2.Models.Users{} = user} <-
           AtriaTask2.Models.Users.find_by_username_and_password(user, pass) do
      assign(conn, :current_user, user)
    else
      _ ->
        conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end
