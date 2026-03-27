require "test_helper"

class Api::GuildsControllerTest < ActionController::TestCase
  tests Api::GuildsController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:one)
  end

  test "show renders the serialized guild" do
    get :show, params: { id: guilds(:one).id }, as: :json

    assert_response :ok
    assert_equal guilds(:one).name, json_body["name"]
  end

  test "create renders the created guild" do
    post :create, params: {
      name: "Bad Guild!",
      description: "Test"
    }, as: :json

    assert_response :created
    assert_equal "Bad Guild!", json_body["name"]
  end

  test "create returns validation errors when required attributes are missing" do
    post :create, params: {
      name: "",
      description: "Test"
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "record_invalid", json_body.dig("error", "code")
    assert_match(/Name can't be blank/, json_body.dig("error", "message"))
  end

  test "update returns validation errors for duplicate guild names" do
    sign_out :user
    sign_in users(:two)

    patch :update, params: {
      id: guilds(:two).id,
      name: guilds(:one).name,
      description: guilds(:two).description,
      owner_id: guilds(:two).owner_id
    }, as: :json

    assert_response :unprocessable_entity
    assert_json_error(code: "record_invalid", message: "Name has already been taken")
  end

  test "show returns unauthorized when the user is not logged in" do
    sign_out :user

    get :show, params: { id: guilds(:one).id }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "You need to sign in or sign up before continuing.")
  end
end
