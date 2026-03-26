require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email before validation" do
    user = build_user(email: " TEST@Example.COM ")

    user.valid?

    assert_equal "test@example.com", user.email
  end

  test "requires username email and profile picture path" do
    user = User.new

    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
    assert_includes user.errors[:email], "can't be blank"
    assert_equal "default_profile_pic.png", user.profile_picture_path
  end

  test "enforces unique username and email" do
    duplicate = build_user(username: users(:one).username, email: users(:one).email)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:username], "has already been taken"
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "serializes the public fields only" do
    payload = users(:one).as_json

    assert_equal %w[email id profile_picture_path username], payload.keys.sort
    assert_equal users(:one).username, payload["username"]
  end

  test "encodes and loads password hashes" do
    user = build_user
    digest = user.encode_password("secret")
    password = user.load_password_hash(digest)

    assert password == "secret"
  end

  private

  def build_user(overrides = {})
    User.new({
      username: "user_#{SecureRandom.hex(4)}",
      email: "user_#{SecureRandom.hex(4)}@example.com",
      password: "secret",
      profile_picture_path: "default_profile_pic.png"
    }.merge(overrides))
  end
end
