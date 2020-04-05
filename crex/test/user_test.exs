defmodule UserTest do
  use ExUnit.Case, async: true
  alias Crex.User

  test "password" do
    encrypted_password = Bcrypt.hash_pwd_salt("hello")

    assert Bcrypt.verify_pass("awsome", encrypted_password) === false
    assert Bcrypt.verify_pass("hello", encrypted_password) === true
  end

  test "create" do
    {:ok, user} =
      User.create(
        id: Crex.Utils.generate_id(),
        password: "hello world",
        email: "hannes.nevalainen@me.com",
        phone: "+132320001",
        registered_at: DateTime.utc_now()
      )

    assert user.password != "hello world"

    refute User.verify_password(user, "hello")
    assert User.verify_password(user, "hello world")
  end
end
