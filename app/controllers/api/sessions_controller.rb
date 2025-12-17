module Api
  class SessionsController < ApplicationController
    protect_from_forgery with: :null_session
    # login
    def create
      email = params[:email]
      password = params[:password]
      user = User.find_by(email: email)
      begin
        BCrypt::Password.new(user.password_digest)
      rescue NoMethodError
        render json: { error: "Invalid password or email" }, status: :unauthorized
      else
        if BCrypt::Password.new(user.password_digest) == password
          @token = encode_tokenjwt({ user_id: user.uuid })
          render json: { user: user.as_json, token: @token }, status: :ok
        else
          render json: { error: "Invalid password or email" }, status: :unauthorized
        end
      end
    end
    # return the current logged user
    def index
      current_user
      if @current_user
        render json: @current_user.as_json, status: :ok
      else
        render json: { error: "Authentification error: Invalid token" }, status: :unauthorized
      end
    end

    def destroy # need to test
      render json: @token = nil, status: :ok
    end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end
  end
  # logout
end
