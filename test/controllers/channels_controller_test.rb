require "test_helper"

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup { @channel = Channel.take }

  test "create_success_without_guild" do
    post "/api/channels", params: { channel: { name: "Test text channel3", category: "text", description: "This is a test channel2" } }

    assert_response(:ok)
  end

  test "create_success_with_guild" do
    post "/api/channels", params: { channel: { name: "Test text channel3", category: "text", description: "This is a test channel2", guild_id: "600a75db-1486-4719-bbb8-776e4cbebde1" } }

    assert_response(:ok)
  end

  test "create_failure_guildNotFound" do
    post "/api/channels", params: { channel: { name: "Test text channel3", category: "text", description: "This is a test channel2", guild_id: "Not gonna be found" } }

    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response
  end

  test "create_failure_duplicate" do
    post "/api/channels", params: { channel: { name: "test-text-channel2", category: "text", description: "This is a test channel", guild_id: "600a75db-1486-4719-bbb8-776e4cbebde1" } }

    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The channel name has already be taken in this place", response
  end

  test "show_success" do
    get "/api/channels/700a75db-1486-4719-bbb8-776e4cbebde1"

    response = JSON.parse(@response.body)
    assert_equal channels(:one).name, response["name"]
  end

  test "show_failure_channelNotFound" do
    get "/api/channels/050"

    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The channel was not found", response
  end

  test "update_success" do
    patch "/api/channels/701a75db-1486-4719-bbb8-776e4cbebde1", params: { name: "TTC3", category: "text", description: "just a test" }
    assert_response(:ok)

    get "/api/channels/701a75db-1486-4719-bbb8-776e4cbebde1"
    response = JSON.parse(@response.body)
    assert_equal "TTC3", response["name"]
  end

  test "update_failure_channel" do
    patch "/api/channels/050", params: { name: "TTC3", category: "text", description: "just a test" }
    assert_response(:unprocessable_entity)

    response = JSON.parse(@response.body)
    assert_equal "The channel data is invalid", response
  end

  test "update_failure_duplicate" do
    patch "/api/channels/701a75db-1486-4719-bbb8-776e4cbebde1", params: { name: "test-voice-channel", category: "voice", description: "just a test", guild_id: "600a75db-1486-4719-bbb8-776e4cbebde1" }
    assert_response(:unprocessable_entity)

    response = JSON.parse(@response.body)
    assert_equal "The channel name has already be taken in this place", response
  end

  test "destroy_success" do
    get "/api/channels/702a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)
    delete "/api/channels/702a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)

    get "/api/channels/702a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The channel was not found", response
  end

  test "destroy_failure_channelNotFound" do
    delete "/api/channels/050"
    assert_response(:not_found)

    response = JSON.parse(@response.body)
    assert_equal "The channel was not found", response
  end
end
