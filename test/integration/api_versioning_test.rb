require "test_helper"

class ApiVersioningTest < ActionDispatch::IntegrationTest
  test "routes api docs to the docs controller" do
    assert_routing(
      { method: "get", path: "/api/docs" },
      { controller: "api/docs", action: "show" }
    )
  end

  test "routes the openapi document" do
    assert_routing(
      { method: "get", path: "/api/openapi.json" },
      { controller: "api/docs", action: "openapi", format: :json }
    )
  end

  test "routes versioned session creation to the api sessions controller" do
    assert_routing(
      { method: "post", path: "/api/v1/sessions" },
      { controller: "api/v1/sessions", action: "create", format: :json }
    )
  end

  test "routes versioned user lookup to the api users controller" do
    assert_routing(
      { method: "get", path: "/api/v1/users/123" },
      { controller: "api/v1/users", action: "show", id: "123", format: :json }
    )
  end

  test "routes versioned guild channel lookup to the api guilds controller" do
    assert_routing(
      { method: "get", path: "/api/v1/guilds/123/channels" },
      { controller: "api/v1/guilds", action: "channels", id: "123", format: :json }
    )
  end
end
