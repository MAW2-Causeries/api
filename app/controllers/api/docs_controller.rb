module Api
  class DocsController < ActionController::Base
    def show
      render html: <<~HTML.html_safe, layout: false
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Causerie API Docs</title>
            <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css">
            <style>
              html {
                box-sizing: border-box;
                overflow-y: scroll;
              }

              *,
              *::before,
              *::after {
                box-sizing: inherit;
              }

              body {
                margin: 0;
                background: #f4f6fb;
              }
            </style>
          </head>
          <body>
            <div id="swagger-ui"></div>
            <script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js" crossorigin></script>
            <script>
              window.ui = SwaggerUIBundle({
                url: "/api/openapi.json",
                dom_id: "#swagger-ui",
                deepLinking: true,
                displayRequestDuration: true,
                presets: [SwaggerUIBundle.presets.apis],
                layout: "BaseLayout"
              });
            </script>
          </body>
        </html>
      HTML
    end

    def openapi
      send_file Rails.root.join("public/openapi.json"), type: "application/json", disposition: "inline"
    end
  end
end
