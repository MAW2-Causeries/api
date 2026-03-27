require "test_helper"

class Api::V1::GuildInvitesControllerTest < ActionController::TestCase
  tests Api::V1::GuildInvitesController

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "join adds the current user to the guild" do
    invite = GuildInvite.create!(guild: guilds(:one), creator: users(:one))
    sign_in users(:two)

    assert_not_includes guilds(:one).members, users(:two)

    post :join, params: { token: invite.token }, as: :json

    assert_response :created
    assert_equal guilds(:one).id, json_body.dig("guild", "id")
    assert_equal invite.token, json_body.dig("invite", "token")
    assert_includes guilds(:one).members.reload, users(:two)
  end

  test "join is idempotent for an existing member" do
    invite = GuildInvite.create!(guild: guilds(:one), creator: users(:one))
    guilds(:one).members << users(:two)
    sign_in users(:two)

    assert_no_difference("guilds(:one).members.reload.count") do
      post :join, params: { token: invite.token }, as: :json
    end

    assert_response :ok
  end

  test "join returns not found for an unknown token" do
    sign_in users(:two)

    post :join, params: { token: "missing-token" }, as: :json

    assert_response :not_found
    assert_equal "record_not_found", json_body.dig("error", "code")
    assert_match(/Couldn't find GuildInvite/, json_body.dig("error", "message"))
  end

  test "join returns unauthorized when not signed in" do
    invite = GuildInvite.create!(guild: guilds(:one), creator: users(:one))

    post :join, params: { token: invite.token }, as: :json

    assert_response :unauthorized
    assert_json_error(code: "authentication_error", message: "You need to sign in or sign up before continuing.")
  end
end
