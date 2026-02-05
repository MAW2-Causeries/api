require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  require "test_helper"
  setup { @user = User.take }

  test "login_success" do
    post "/api/sessions", params: { email: "test@test.com", password: "test" }
    response = JSON.parse(@response.body)
    assert_equal users(:one).username, response["user"]["username"]
  end

    test "login_failure_wrong_input" do
    post "/api/sessions", params: { email: "teest@test.com", password: "test" }

    assert_response(:unauthorized)
    response = JSON.parse(@response.body)
    assert_equal "The user data is invalid", response
  end

  test "current_user_success" do
    # login to get token
    post "/api/sessions", params: { email: "teste@test.com", password: "test" }
    response = JSON.parse(@response.body)
    token = response["token"]

    # check token by comparing both username
    get "/api/sessions", params: { Authorization: token }
    response = JSON.parse(@response.body)

    assert_equal users(:two).username, response["username"]
  end

  test "current_user_failure" do
    get "/api/sessions", params: { Authorization: "I am the token" }
    assert_response(:unauthorized)
    response = JSON.parse(@response.body)
    assert_equal "Invalid token", response
  end

  test "logout_success" do
    delete "/api/sessions"
    assert_response(:ok)
  end
end
