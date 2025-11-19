module Api
  class UsersController < ApplicationController
    allow_unauthenticated_access
        skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    before_action :log_raw_body, only: %i[register login]

    def new
    end

    def register
            # accept both :email and :email_address from clients (forms or JSON)
            attrs =
        if params[:user].present?
          user_params.to_h
        else
          # permit top-level keys when client sends non-nested JSON
          params.permit(:email, :password, :username, :profile_picture_path).to_h
        end

      user = User.new(attrs)
      if user.save
        # token generator
        start_new_session_for(user)
        render json: { user: { id: user.id, username: user.username, email: user.email }, token: token }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      email = params[:email]
      password = params[:password]
      user = User.find_by(email: email)
      if user&.authenticate(params[password])
        token = generate_token(user)
        start_new_session_for(user)
        render json: { user: { id: user.id, username: user.username }, token: token }, status: :ok
      elsif user
        render json: { error: "Invalid password" }, status: :unauthorized
      else
        render json: { error: "User not found" }, status: :not_found
      end
    end

    def logout
      authenticate_user!
      current_user.sessions.destroy_all
      render json: { message: "Logged out successfully" }, status: :ok
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username, :profile_picture_path)
    end


    private def log_raw_body
      raw = request.body.read
      Rails.logger.info "RAW REQUEST BODY: #{raw.inspect}"
      request.body.rewind
    end
  end
end
