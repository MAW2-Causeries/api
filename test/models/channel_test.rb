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
    channel = TextChannel.new(name: "General Chat!!", type: "TextChannel", guild: guilds(:one))

    assert_equal "generalchat", channel.reformatted_name
  end

  test "normalizes invalid names before validation" do
    channel = build_channel(name: "General Chat!!")

    assert channel.valid?
    assert_equal "generalchat", channel.name
  end

  test "serializes the public fields only" do
    payload = channels(:two).as_json

    assert_equal %w[description id name type], payload.keys.sort
    assert_equal "DMChannel", payload["type"]
  end

  test "dm channel serialization includes users under a string key" do
    channel = DMChannel.create!(
      name: "private",
      type: "DMChannel",
      users: [ users(:one), users(:two) ]
    )

    payload = channel.as_json

    assert_includes payload.keys, "users"
    assert_equal [ users(:one).id, users(:two).id ].sort, payload["users"].map { |user| user["id"] }.sort
  end

  test "text channels require a guild" do
    channel = TextChannel.new(name: "general", type: "TextChannel")

    assert_not channel.valid?
    assert_includes channel.errors[:guild_id], "can't be blank"
  end

  test "private channels cannot belong to a guild" do
    channel = DMChannel.new(name: "private", type: "DMChannel", guild_id: guilds(:one).id)

    assert_not channel.valid?
    assert_includes channel.errors[:guild_id], "must be blank"
  end

  test "dm channels accept exactly two users" do
    channel = DMChannel.new(
      name: "private",
      type: "DMChannel",
      users: [ users(:one), users(:two) ]
    )

    assert channel.valid?
  end

  test "dm channels require two distinct users" do
    channel = DMChannel.new(
      name: "private",
      type: "DMChannel",
      users: [ users(:one), users(:one) ]
    )

    assert_not channel.valid?
    assert_includes channel.errors[:users], "must be different users"
  end

  test "between_users finds an existing dm regardless of order" do
    channel = DMChannel.create!(
      name: "private",
      type: "DMChannel",
      users: [ users(:three), users(:four) ]
    )

    assert_equal channel, DMChannel.between_users(users(:four), users(:three))
  end

  private

  def build_channel(overrides = {})
    TextChannel.new({
      name: "channel-#{SecureRandom.hex(4)}",
      type: "TextChannel",
      description: "Test channel",
      guild_id: guilds(:one).id
    }.merge(overrides))
  end
end
