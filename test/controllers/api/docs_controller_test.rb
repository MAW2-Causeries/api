require "test_helper"

class Api::DocsControllerTest < ActionDispatch::IntegrationTest
  test "serves swagger ui at /api/docs" do
    get "/api/docs"

    assert_response :success
    assert_equal "text/html; charset=utf-8", response.content_type
    assert_includes response.body, "SwaggerUIBundle"
    assert_includes response.body, "/api/openapi.json"
  end

  test "serves the openapi document at /api/openapi.json" do
    get "/api/openapi.json"

    assert_response :success
    assert_equal "application/json", response.media_type
    assert_equal "3.0.3", json_body["openapi"]
    assert_equal "Causerie API", json_body.dig("info", "title")
  end
end
