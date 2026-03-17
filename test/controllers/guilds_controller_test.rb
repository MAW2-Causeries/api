require "test_helper"

class GuildsControllerTest < ActionDispatch::IntegrationTest
setup { @guild = Guild.take }
  test "create_success" do
    post "/api/guilds", params: { guild: { name: "TestGuilde", description: "This is a test guild", owner_id: "501a75db-1486-4719-bbb8-776e4cbebde1", creator_id: "501a75db-1486-4719-bbb8-776e4cbebde1", banner_picture_path: "default_banner.png" } }
    assert_response(:ok)
  end

  test "create_failure_userNotFound" do
    post "/api/guilds", params: { guild: { name: "TestGuilding", description: "This is a test guild", banner_picture_path: "default_banner.png" } }
    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The user was not found", response
  end

  test "create_failure_duplicate" do
    post "/api/guilds", params: { guild: { name: "TestGuild", description: "This is a test guild", owner_id: "501a75db-1486-4719-bbb8-776e4c1bebde1", creator_id: "501a75db-1486-4719-bbb8-776e14cbebde1",  banner_picture_path: "default_banner.png" } }
    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The user was not found", response
  end

  test "show_success" do
    get "/api/guilds/600a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)
    response = JSON.parse(@response.body)
    assert_equal guilds(:one).name, response["name"]
  end

  test "show_failure_guildNotFound" do
    get "/api/guilds/050"
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response
  end

  test "update_success" do
    patch "/api/guilds/601a75db-1486-4719-bbb8-776e4cbebde1", params: { name: "Guild2 updated", description: "yup updated", banner_picture_path: "default_banner.png", owner_id: "500a75db-1486-4719-bbb8-776e4cbebde1" }
    assert_response(:ok)

    get "/api/guilds/601a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)
    response = JSON.parse(@response.body)
    assert_equal "Guild2 updated", response["name"]
  end

  test "update_failure_guildNotFound" do
    patch "/api/guilds/050", params: { name: "Guild2updated", description: "yup updated", banner_picture_path: "default_banner.png" }
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response
  end

  test "update_failure_duplicate" do
    patch "/api/guilds/601a75db-1486-4719-bbb8-776e4cbebde1", params: { name: "Test Guild", description: "yup updated", banner_picture_path: "default_banner.png", owner_id: "500a75db-1486-4719-bbb8-776e4cbebde1" }
    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The guild name has already be taken", response
  end

  test "destroy_success" do
    delete "/api/guilds/602a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)

    get "/api/guilds/602a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response
  end

  test "destroy_failure_guildNotFound" do
    delete "/api/guilds/050"
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response
  end
end
