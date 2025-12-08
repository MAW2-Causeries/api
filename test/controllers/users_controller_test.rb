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

  test "register_success" do
    post "/api/users", params: { user: { email: "testing@test.com", password: "password", username: "testoting" } }

    assert_response(:success)
  end

  test "check_token_success" do
    post "/api/sessions", params: { email: "teste@test.com", password: "test" }
    response = JSON.parse(@response.body)
    token = response["token"]

    get "/api/sessions", params: { Authorization: token }
    response = JSON.parse(@response.body)

    assert_equal users(:two).username, response["username"]
  end
end
