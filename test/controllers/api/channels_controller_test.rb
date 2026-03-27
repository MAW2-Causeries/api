require "test_helper"

class Api::ChannelsControllerTest < ActionController::TestCase
  tests Api::ChannelsController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:one)
  end

  test "show renders the serialized channel" do
    get :show, params: { id: channels(:one).id }, as: :json

    assert_response :ok
    assert_equal channels(:one).name, json_body["name"]
  end

  test "create returns validation errors for missing type" do
    post :create, params: {
      name: "new-channel",
      description: "Test",
      guild_id: channels(:two).guild_id
    }, as: :json

    assert_response :unprocessable_entity
    assert_json_error(code: "record_invalid", message: "Type can't be blank")
  end

  test "update returns not found when the channel does not exist" do
    patch :update, params: { id: "missing", name: "general", description: "Test" }, as: :json

    assert_response :not_found
    assert_equal "record_not_found", json_body.dig("error", "code")
    assert_match(/Couldn't find Channel/, json_body.dig("error", "message"))
  end

  test "show returns unauthorized when the user is not logged in" do
    sign_out :user

    get :show, params: { id: channels(:one).id }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "You need to sign in or sign up before continuing.")
  end
end
