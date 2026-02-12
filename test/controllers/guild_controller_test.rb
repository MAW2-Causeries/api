require "test_helper"

class GuildControllerTest < ActionDispatch::IntegrationTest
setup { @guild = Guild.take }
  test "create_success" do
    post "/api/guilds", params: { guild: { name: "Test Guild", description: "This is a test guild", user_id: "500a75db-1486-4719-bbb8-776e4cbebde1", banner_picture_path: "default_banner.png"} }
    assert_response(:ok)
  end

  test "create_failure_userNotFound" do
    post "/api/guilds", params: { guild: { name: "Test Guild", description: "This is a test guild", user_id: "Not gonna be found", banner_picture_path: "default_banner.png"} }
    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The user was not found", response["error"]
  end

  test "create_failure_duplicate" do
    post "/api/guilds", params: { guild: { name: "Test Guild", description: "This is a test guild", user_id: "500a75db-1486-4719-bbb8-776e4cbebde1", banner_picture_path: "default_banner.png"} }
    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The guild name has already be taken", response["error"]
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
    assert_equal "The guild was not found", response["error"]
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
    patch "/api/guilds/050", params: { name: "Guild2 updated", description: "yup updated", banner_picture_path: "default_banner.png"}
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response["error"]
  end 

  test "update_failure_duplicate" do
    patch "api/guilds/601a75db-1486-4719-bbb8-776e4cbebde1", params: { name: "Test Guild", description: "yup updated", banner_picture_path: "default_banner.png", owner_id: "500a75db-1486-4719-bbb8-776e4cbebde1" }
    assert_response(:unprocessable_entity)
    response = JSON.parse(@response.body)
    assert_equal "The guild name has already be taken", response["error"]
  end

  test "destroy_success" do
    delete "/api/guilds/602a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:ok)

    get "/api/guilds/602a75db-1486-4719-bbb8-776e4cbebde1"
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response["error"]
  end 

  test "destroy_failure_guildNotFound" do
    delete "/api/guilds/050"
    assert_response(:not_found)
    response = JSON.parse(@response.body)
    assert_equal "The guild was not found", response["error"]
  end 
end
