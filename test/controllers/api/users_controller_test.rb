require "test_helper"

class Api::V1::UsersControllerTest < ActionController::TestCase
  tests Api::V1::UsersController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:one)
  end

  test "show renders the serialized user" do
    get :show, params: { id: users(:one).id }, as: :json

    assert_response :ok
    assert_equal users(:one).username, json_body["username"]
  end

  test "create returns validation errors for invalid usernames" do
    post :create, params: {
      email: "new@example.com",
      password: "secret",
      username: "bad name!"
    }, as: :json

    assert_response :unprocessable_entity
    assert_json_error(code: "record_invalid", message: "Username must contain only letters and numbers")
  end

  test "create returns uniqueness errors for duplicate users" do
    post :create, params: {
      email: users(:one).email,
      password: "secret",
      username: "anothername"
    }, as: :json

    assert_response :unprocessable_entity
    assert_json_error(code: "record_invalid", message: "Email has already been taken")
  end

  test "update accepts top-level user attributes" do
    patch :update, params: {
      id: users(:one).id,
      username: "renameduser"
    }, as: :json

    assert_response :ok
    assert_equal "renameduser", users(:one).reload.username
  end

  test "destroy returns not found when the user does not exist" do
    delete :destroy, params: { id: "missing" }, as: :json

    assert_response :not_found
    assert_equal "record_not_found", json_body.dig("error", "code")
    assert_match(/Couldn't find User/, json_body.dig("error", "message"))
  end

  test "show returns unauthorized when the user is not logged in" do
    sign_out :user

    get :show, params: { id: users(:one).id }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "You need to sign in or sign up before continuing.")
  end

  test "show bypasses jwt authentication for configured hosts" do
    previous_hosts = ENV["API_JWT_BYPASS_HOSTS"]
    ENV["API_JWT_BYPASS_HOSTS"] = "trusted.local"
    sign_out :user
    @request.host = "trusted.local"

    get :show, params: { id: users(:one).id }, as: :json

    assert_response :ok
    assert_equal users(:one).username, json_body["username"]
  ensure
    ENV["API_JWT_BYPASS_HOSTS"] = previous_hosts
  end
end
