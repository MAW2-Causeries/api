require "test_helper"

class ChannelTest < ActiveSupport::TestCase
  test "fixture channel is valid" do
    assert channels(:one).valid?
  end

  test "requires name and type" do
    channel = Channel.new

    assert_not channel.valid?
    assert_includes channel.errors[:name], "can't be blank"
    assert_includes channel.errors[:type], "can't be blank"
  end

  test "reformats names into channel slugs" do
    channel = Channel.new(name: "General Chat!!", type: "text")

    assert_equal "generalchat", channel.reformatted_name
  end

  test "normalizes invalid names before validation" do
    channel = build_channel(name: "General Chat!!")

    assert channel.valid?
    assert_equal "generalchat", channel.name
  end

  test "serializes the public fields only" do
    payload = channels(:two).as_json

    assert_equal %w[description guild_id id name], payload.keys.sort
    assert_equal channels(:two).guild_id, payload["guild_id"]
  end

  private

  def build_channel(overrides = {})
    Channel.new({
      name: "channel-#{SecureRandom.hex(4)}",
      type: "text",
      description: "Test channel",
      guild_id: guilds(:one).id
    }.merge(overrides))
  end
end
