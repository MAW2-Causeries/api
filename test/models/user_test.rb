require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes email before validation" do
    user = build_user(email: " TEST@Example.COM ")

    user.valid?

    assert_equal "test@example.com", user.email
  end

  test "requires username and email" do
    user = User.new

    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
    assert_includes user.errors[:email], "can't be blank"
  end

  test "enforces unique username and email" do
    duplicate = build_user(username: users(:one).username, email: users(:one).email)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:username], "has already been taken"
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "restricts username to alphanumeric characters" do
    user = build_user(username: "bad name!")

    assert_not user.valid?
    assert_includes user.errors[:username], "must contain only letters and numbers"
  end

  test "serializes the public fields only" do
    payload = users(:one).as_json

    assert_equal %w[email id username], payload.keys.sort
    assert_equal users(:one).username, payload["username"]
  end

  test "true_all_channels returns dm and guild channels" do
    assert_equal [ channels(:one), channels(:two), channels(:three) ].map(&:id).sort,
      users(:one).true_all_channels.pluck(:id).sort
  end

  test "authenticates passwords through devise" do
    user = build_user
    user.save!

    assert user.valid_password?("secret")
    assert_not user.valid_password?("wrong-password")
  end

  private

  def build_user(overrides = {})
    User.new({
      username: "user#{SecureRandom.hex(4)}",
      email: "user#{SecureRandom.hex(4)}@example.com",
      password: "secret"
    }.merge(overrides))
  end
end
