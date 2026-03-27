require "test_helper"

class Api::V1::GuildsControllerTest < ActionController::TestCase
  tests Api::V1::GuildsController

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
    assert_includes Guild.find(json_body["id"]).members, users(:one)
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

  test "update allows duplicate guild names for the guild owner" do
    sign_out :user
    sign_in users(:two)

    patch :update, params: {
      id: guilds(:two).id,
      name: guilds(:one).name,
      description: guilds(:two).description,
      owner_id: guilds(:two).owner_id
    }, as: :json

    assert_response :ok
    assert_equal guilds(:one).name, guilds(:two).reload.name
  end

  test "channels returns the guild channels for a member" do
    get :channels, params: { id: guilds(:one).id }, as: :json

    assert_response :ok
    assert_equal guilds(:one).channels.count, json_body.length
  end

  test "members returns the guild members for an authorized user" do
    guild = guilds(:one)
    guild.members << users(:two)

    get :members, params: { id: guild.id }, as: :json

    assert_response :ok
    assert_equal [ users(:one).id, users(:two).id ].sort, json_body.map { |member| member["id"] }.sort
  end

  test "members returns forbidden when the user is not in the guild" do
    sign_out :user
    sign_in users(:three)

    get :members, params: { id: guilds(:one).id }, as: :json

    assert_response :forbidden
    assert_json_error(code: "forbidden", message: "You don't have access to this guild")
  end

  test "invite creates a reusable invite link for the guild owner" do
    assert_difference("GuildInvite.count", 1) do
      post :invite, params: { id: guilds(:one).id }, as: :json
    end

    assert_response :created
    assert_equal guilds(:one).id, json_body["guild_id"]
    assert_equal users(:one).id, json_body["creator_id"]
    assert json_body["token"].present?
    assert_equal "/api/v1/guild_invites/#{json_body["token"]}/join", json_body["invite_url"]
  end

  test "invite returns forbidden for non owners" do
    guilds(:one).members << users(:two)
    sign_out :user
    sign_in users(:two)

    post :invite, params: { id: guilds(:one).id }, as: :json

    assert_response :forbidden
    assert_json_error(code: "forbidden", message: "Only the owner of the guild can perform this action")
  end

  test "show returns unauthorized when the user is not logged in" do
    sign_out :user

    get :show, params: { id: guilds(:one).id }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "You need to sign in or sign up before continuing.")
  end
end
