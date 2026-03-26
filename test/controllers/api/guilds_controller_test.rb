require "test_helper"

class Api::GuildsControllerTest < ActionController::TestCase
  tests Api::GuildsController

  test "show renders the serialized guild" do
    get :show, params: { id: guilds(:one).id }, as: :json

    assert_response :ok
    assert_equal guilds(:one).name, json_body["name"]
  end

  test "create rejects names with non alphanumeric characters" do
    post :create, params: {
      guild: {
        name: "Bad Guild!",
        description: "Test",
        owner_id: users(:one).id,
        creator_id: users(:one).id,
        banner_picture_path: "default_banner.png"
      }
    }, as: :json

    assert_response :bad_request
    assert_equal "The guild data is invalid", json_body
  end

  test "create returns user not found when owners are missing" do
    post :create, params: {
      guild: {
        name: "ValidGuild",
        description: "Test",
        owner_id: "missing-owner",
        creator_id: "missing-creator",
        banner_picture_path: "default_banner.png"
      }
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "The user was not found", json_body
  end

  test "update maps record conflicts to duplicate guild responses" do
    patch :update, params: {
      id: guilds(:two).id,
      name: guilds(:one).name,
      description: guilds(:two).description,
      banner_picture_path: guilds(:two).banner_picture_path,
      owner_id: guilds(:two).owner_id
    }, as: :json

    assert_response :unprocessable_entity
    assert_equal "The guild name has already be taken", json_body
  end
end
