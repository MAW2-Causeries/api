require "test_helper"

class ChannelTest < ActiveSupport::TestCase
  test "fixture channel is valid" do
    assert channels(:one).valid?
  end

  test "requires name and category" do
    channel = Channel.new

    assert_not channel.valid?
    assert_includes channel.errors[:name], "can't be blank"
    assert_includes channel.errors[:category], "can't be blank"
  end

  test "enforces unique name within guild and category" do
    duplicate = build_channel(name: channels(:two).name, guild_id: channels(:two).guild_id, category: channels(:two).category)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "allows same name in another category" do
    channel = build_channel(name: channels(:two).name, guild_id: channels(:two).guild_id, category: "voice")

    assert channel.valid?
  end

  test "reformats names into channel slugs" do
    channel = Channel.new(name: "General Chat!!")

    assert_equal "generalchat", channel.reformatted_name
  end

  test "serializes the public fields only" do
    payload = channels(:two).as_json

    assert_equal %w[category description guild_id id name], payload.keys.sort
    assert_equal channels(:two).guild_id, payload["guild_id"]
  end

  private

  def build_channel(overrides = {})
    Channel.new({
      name: "channel-#{SecureRandom.hex(4)}",
      category: "text",
      description: "Test channel",
      guild_id: guilds(:one).id
    }.merge(overrides))
  end
end
