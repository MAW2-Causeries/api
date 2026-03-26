require "test_helper"

class Api::UsersControllerTest < ActionController::TestCase
  tests Api::UsersController

  test "show renders the serialized user" do
    get :show, params: { id: users(:one).id }, as: :json

    assert_response :ok
    assert_equal users(:one).username, json_body["username"]
  end

  test "create rejects usernames with non alphanumeric characters" do
    post :create, params: {
      user: {
        email: "new@example.com",
        password: "secret",
        username: "bad name!",
        profile_picture_path: "default_profile_pic.png"
      }
    }, as: :json

    assert_response :bad_request
    assert_equal "The user data is invalid", json_body
  end

  test "create maps persistence conflicts to duplicate user responses" do
    post :create, params: {
      user: {
        email: users(:one).email,
        password: "secret",
        username: "anothername",
        profile_picture_path: "default_profile_pic.png"
      }
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "The username and/or email has already been taken", json_body
  end

  test "destroy returns not found when the user does not exist" do
    delete :destroy, params: { id: "missing" }, as: :json

    assert_response :not_found
    assert_equal "The user was not found", json_body
  end
end
