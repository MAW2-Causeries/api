require "test_helper"

class Api::ChannelsControllerTest < ActionController::TestCase
  tests Api::ChannelsController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:one)
    @accessible_dm_channel = DMChannel.create!(
      name: "private-chat",
      type: "DMChannel",
      users: [ users(:one), users(:two) ]
    )
  end

  test "show renders the serialized channel" do
    get :show, params: { id: @accessible_dm_channel.id }, as: :json

    assert_response :ok
    assert_equal @accessible_dm_channel.name, json_body["name"]
  end

  test "users returns the channel users for an authorized member" do
    get :users, params: { id: @accessible_dm_channel.id }, as: :json

    assert_response :ok
    assert_equal [ users(:one).id, users(:two).id ].sort, json_body.map { |user| user["id"] }.sort
  end

  test "create returns invalid channel type for missing type" do
    post :create, params: {
      name: "new-channel",
      description: "Test",
      guild_id: channels(:two).guild_id
    }, as: :json

    assert_response :bad_request
    assert_json_error(code: "invalid_channel_type", message: "Invalid channel type: ")
  end

  test "create builds a text channel in a guild" do
    post :create, params: {
      name: "General Chat!!",
      description: "Guild room",
      guild_id: guilds(:one).id,
      type: "text"
    }, as: :json

    assert_response :created
    assert_equal "generalchat", json_body["name"]
    assert_equal "TextChannel", json_body["type"]
    assert_nil json_body["guild_id"]
  end

  test "create requires a target user for dm channels" do
    post :create, params: {
      name: "direct-message",
      description: "Private room",
      guild_id: guilds(:one).id,
      type: "dm"
    }, as: :json

    assert_response :not_found
    assert_json_error(code: "record_not_found", message: "Couldn't find User with [WHERE \"users\".\"id\" IS NULL]")
  end

  test "update returns not found when the channel does not exist" do
    patch :update, params: { id: "missing", name: "general", description: "Test" }, as: :json

    assert_response :not_found
    assert_equal "record_not_found", json_body.dig("error", "code")
    assert_match(/Couldn't find Channel/, json_body.dig("error", "message"))
  end

  test "destroy removes a text channel for the guild owner" do
    guilds(:one).members << users(:one)

    assert_difference("Channel.count", -1) do
      delete :destroy, params: { id: channels(:one).id }, as: :json
    end

    assert_response :no_content
  end

  test "destroy returns not found for a non-owner" do
    guilds(:one).members << users(:one)
    sign_out :user
    sign_in users(:two)

    delete :destroy, params: { id: channels(:one).id }, as: :json

    assert_response :not_found
    assert_equal "record_not_found", json_body.dig("error", "code")
  end

  test "show returns unauthorized when the user is not logged in" do
    sign_out :user

    get :show, params: { id: channels(:one).id }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "You need to sign in or sign up before continuing.")
  end
end
