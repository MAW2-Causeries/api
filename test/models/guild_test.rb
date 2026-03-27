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

  test "enforces unique guild names" do
    duplicate = build_guild(name: guilds(:one).name)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "serializes the public fields only" do
    payload = guilds(:one).as_json

    assert_equal %w[description id name owner_id], payload.keys.sort
    assert_equal guilds(:one).id, payload["id"]
  end

  test "destroys dependent channels" do
    guild = guilds(:one)

    assert_difference("Channel.where(guild_id: guild.id).count", -2) do
      guild.destroy
    end
  end

  test "exposes owner and creator associations" do
    guild = guilds(:one)

    assert_equal users(:one), guild.owner
    assert_equal users(:one), guild.creator
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
