require "test_helper"

class Api::SessionsControllerTest < ActionController::TestCase
  tests Api::SessionsController

  test "create returns unauthorized when the user is missing" do
    post :create, params: { email: "missing@example.com", password: "secret" }, as: :json

    assert_response :unauthorized
    assert_equal "The user data is invalid", json_body
  end

  test "create returns the serialized user and token on success" do
    user = users(:one)

    post :create, params: { email: user.email, password: "test" }, as: :json

    assert_response :ok
    assert_equal user.username, json_body["user"]["username"]
    assert json_body["token"].present?
  end

  test "index returns unauthorized for an invalid token" do
    get :index, params: { Authorization: "bad-token" }, as: :json

    assert_response :unauthorized
    assert_equal "Invalid token", json_body
  end

  test "destroy returns ok" do
    delete :destroy, as: :json

    assert_response :ok
  end
end
