module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json
      skip_before_action :authenticate_api_user!

      def create
        user = User.find_for_database_authentication(email: params[:email])
        return render_authentication_error("Invalid password or email") unless user&.valid_password?(params[:password])

        sign_in(resource_name, user, store: false)
        token = request.env["warden-jwt_auth.token"]
        render json: { user: user.as_json, token: token }, status: :ok
      end

      def index
        user = authenticated_user_from_token
        return render_authentication_error("Invalid token") unless user

        render json: user.as_json, status: :ok
      end

      def destroy
        user = authenticated_user_from_token
        return render_authentication_error("Invalid token") unless user

        sign_out(resource_name)
        render body: nil, status: :ok
      end

      private

      def authenticated_user_from_token
        warden.authenticate(scope: resource_name)
      end

      def render_authentication_error(message)
        render_error(message, status: :unauthorized, code: "authentication_error")
      end
    end
  end
end
