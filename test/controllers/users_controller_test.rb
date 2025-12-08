require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #
  # todo : réaliser les tests de login/register et check_token avec les failures possibles -> https://guides.rubyonrails.org/testing.html#maintaining-the-test-database-schema
  require "test_helper"
  setup { @user = User.take }

  test "login_success" do
    post "/api/sessions", params: { email: "test@test.com", password: "test" }
    response = JSON.parse(@response.body)
    assert_equal users(:one).username, response["username"]
  end

    test "login_failure_wrong_input" do
    post "/api/sessions", params: { email: "teest@test.com", password: "test" }

    assert_response(:unauthorized)
    response = JSON.parse(@response.body)
    assert_equal "Invalid password or email", response["error"]
  end

  test "register_success" do
    post "/api/users", params: { user: { email: "testing@test.com", password: "password", username: "testoting" } }

    assert_response(:success)
  end

  test "register_failure_duplicate" do
    post "/api/users", params: { email: "test@test.com", password: "test" }

    assert_response(:forbidden)
    response = JSON.parse(@response.body)
    assert_equal "The username and/or email has already be taken", response["error"]
  end

  test "check_token_success" do
    post "/api/sessions", params: { email: "teste@test.com", password: "test" }
    response = JSON.parse(@response.body)
    token = response["token"]

    get "/api/sessions", params: { Authorization: token }
    response = JSON.parse(@response.body)

    assert_equal users(:two).username, response["username"]
  end

  test "check_token_failure_not_found" do
    get "/api/sessions", params: { Authorization: "I am the token" }
    assert_response(:unauthorized)
    response = JSON.parse(@response.body)
    assert_equal "Authentification error: Invalid token", response["error"]
  end
end
