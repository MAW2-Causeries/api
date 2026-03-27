require "test_helper"

class GuildInviteTest < ActiveSupport::TestCase
  test "creates a token automatically" do
    invite = GuildInvite.create!(guild: guilds(:one), creator: users(:one))

    assert invite.token.present?
    assert_equal "/api/v1/guild_invites/#{invite.token}/join", invite.as_json["invite_url"]
  end

  test "requires guild and creator" do
    invite = GuildInvite.new

    assert_not invite.valid?
    assert_includes invite.errors[:guild], "must exist"
    assert_includes invite.errors[:creator], "must exist"
  end
end
