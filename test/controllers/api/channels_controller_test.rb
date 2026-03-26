require "test_helper"

class Api::ChannelsControllerTest < ActionController::TestCase
  tests Api::ChannelsController

  test "show renders the serialized channel" do
    get :show, params: { id: channels(:one).id }, as: :json

    assert_response :ok
    assert_equal channels(:one).name, json_body["name"]
  end

  test "create reformats names before saving when needed" do
    post :create, params: {
      channel: {
        name: "General Chat!!",
        category: "text",
        description: "Test"
      }
    }, as: :json

    assert_response :ok
    assert_equal "generalchat", Channel.order(:created_at).last.name
  end

  test "create maps record conflicts to duplicate channel responses" do
    post :create, params: {
      channel: {
        name: channels(:two).name,
        category: channels(:two).category,
        description: "Test",
        guild_id: channels(:two).guild_id
      }
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "The channel name has already be taken in this place", json_body
  end

  test "update returns invalid channel data when the record cannot be found" do
    patch :update, params: { id: "missing", name: "general", category: "text", description: "Test" }, as: :json

    assert_response :unprocessable_entity
    assert_equal "The channel data is invalid", json_body
  end
end
