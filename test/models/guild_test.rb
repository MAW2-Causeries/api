require "test_helper"

class GuildTest < ActiveSupport::TestCase
  test "fixture guild is valid" do
    assert guilds(:one).valid?
  end

  test "requires name banner creator and owner" do
    guild = Guild.new

    assert_not guild.valid?
    assert_includes guild.errors[:name], "can't be blank"
    assert_includes guild.errors[:creator_id], "can't be blank"
    assert_includes guild.errors[:owner_id], "can't be blank"
  end

  test "allows duplicate guild names" do
    duplicate = build_guild(name: guilds(:one).name)

    assert duplicate.valid?
  end

  test "serializes the public fields only" do
    payload = guilds(:one).as_json

    assert_equal %w[description id name owner_id], payload.keys.sort
    assert_equal guilds(:one).id, payload["id"]
  end

  test "can have members through the join table" do
    guild = guilds(:one)
    member = users(:two)

    assert_difference("guild.members.count", 1) do
      guild.members << member
    end

    assert_includes guild.members.reload, member
  end

  test "exposes owner and creator associations" do
    guild = guilds(:one)

    assert_equal users(:one), guild.owner
    assert_equal users(:one), guild.creator
  end

  test "invite_member! adds the user once" do
    guild = guilds(:one)
    user = users(:two)

    assert_difference("guild.members.count", 1) do
      guild.invite_member!(user)
    end

    assert_no_difference("guild.members.count") do
      guild.invite_member!(user)
    end
  end

  test "destroys invites when the guild is deleted" do
    guild = guilds(:one)
    GuildInvite.create!(guild: guild, creator: users(:one))

    assert_difference("GuildInvite.count", -1) do
      guild.destroy
    end
  end

  private

  def build_guild(overrides = {})
    user = users(:one)

    Guild.new({
      name: "Guild#{SecureRandom.hex(4)}",
      description: "Test guild",
      owner_id: user.id,
      creator_id: user.id
    }.merge(overrides))
  end
end
