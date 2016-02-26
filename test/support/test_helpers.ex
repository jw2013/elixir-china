defmodule ElixirChina.TestHelpers do
  alias ElixirChina.{Repo, Post, User, Notification}
  alias Plug.Conn

  @user_default_attrs %{name: "david", email: "david@elixir.com", admin: false, password: "password"}
  @post_default_attrs %{title: "Elixir is cool", content: "It's very cool.", category_id: 1, user_id: 1}
  @notification_default_attrs %{user_id: 1, post_id: 1, type: 0}
  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    encryption_salt: "yadayada",
    signing_salt: "yadayada"
  )

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(@user_default_attrs, attrs)
    Repo.insert!(User.changeset(%User{}, changes))
  end

  # This will fail because there foreign key constraint for user_id, so you have to pass it in
  def insert_post(attrs \\ %{}) do
    changes = Map.merge(@post_default_attrs, attrs)
    Repo.insert!(Post.changeset(%Post{}, changes))
  end

  def insert_notification(attrs \\ %{}) do
    changes = Map.merge(@notification_default_attrs, attrs)
    Repo.insert!(Notification.changeset(%Notification{}, changes))
  end

  def put_session(conn, user_id) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Conn.fetch_session()
    |> Conn.put_session(:user_id, user_id)
  end
end
