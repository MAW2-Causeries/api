require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  require "test_helper"
  setup { @user = User.take }

  test "register_success" do
    post "/api/users", params: { user: { email: "testing@test.com", password: "password", username: "testoting" } }

    assert_response(:ok)
  end

  test "register_failure_duplicate" do
    post "/api/users", params: { email: "test@test.com", password: "test" }

    assert_response(:forbidden)
    response = JSON.parse(@response.body)
    assert_equal "The username and/or email has already be taken", response["error"]
  end

  test "show_success" do
    get "/api/users/500a75db-1486-4719-bbb8-776e4cbebde1"
    response = JSON.parse(@response.body)

    assert_equal users(:one).username, response["username"]
  end

  test "show_fail" do
    get "/api/users/050"
    response = JSON.parse(@response.body)

    assert_equal "The user doesn't exist", response["error"]
  end

  test "update_success" do
    patch "/api/users/503a75db-1486-4719-bbb8-776e4cbebde1", params: { profile_picture_path: "default_profile_pic.png", username: "bloblie", password: "test" }
    assert_response(:ok)

    get "/api/users/503a75db-1486-4719-bbb8-776e4cbebde1"
    response = JSON.parse(@response.body)
    assert_equal users(:four).username, response["username"]
  end

  test "update_fail" do
    patch "/api/users/050", params: { profile_picture_path: "default_profile_pic.png", username: "fwefwe", password: "test" }
    response = JSON.parse(@response.body)
    assert_equal "The user couldn't be updated", response["error"]
  end

    test "destroy_success" do
    delete "/api/users/502a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)

    get "/api/users/502a75db-1486-4719-bbb8-776e4cbebde1"
    response = JSON.parse(@response.body)

    assert_equal "The user doesn't exist", response["error"]
  end

    test "destroy_fail" do
    delete "/api/users/050"
    response = JSON.parse(@response.body)
    assert_equal "The user couldn't be delete", response["error"]
  end
end
