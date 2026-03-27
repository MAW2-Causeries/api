require "test_helper"

class Api::V1::SessionsControllerTest < ActionController::TestCase
  tests Api::V1::SessionsController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "create returns unauthorized when the user is missing" do
    post :create, params: { email: "missing@example.com", password: "secret" }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "Invalid password or email")
  end

  test "create returns the serialized user and token on success" do
    user = users(:one)

    post :create, params: { email: user.email, password: "test" }, as: :json

    assert_response :ok
    assert_equal user.username, json_body["user"]["username"]
    assert json_body["token"].present?
  end

  test "index returns unauthorized for an invalid token" do
    @request.headers["Authorization"] = "Bearer bad-token"
    get :index, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "Invalid token")
  end

  test "destroy returns ok with a valid token" do
    user = users(:one)
    post :create, params: { email: user.email, password: "test" }, as: :json

    @request.headers["Authorization"] = "Bearer #{json_body["token"]}"
    delete :destroy, as: :json

    assert_response :ok
  end
end
