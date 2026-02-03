module Api
  class SessionsController < ApplicationController
    protect_from_forgery with: :null_session
    # login
    def create
      email = params[:email]
      password = params[:password]
      user = User.find_by(email: email)
      begin
        user.temporary_password(user.password_digest)
      rescue NoMethodError
        render json: { error: "Invalid password or email" }, status: :unauthorized
      else
        if user.temporary_password(user.password_digest) == password
          @token = helpers.encode_tokenjwt({ user_id: user.uuid })
          render json: { user: user.as_json, token: @token }, status: :ok
        else
          render json: { error: "Invalid password or email" }, status: :unauthorized
        end
      end
    end
    # return the current logged user
    def index
      begin
        current_user= User.find_by(uuid: helpers.decode_tokenjwt[0]["user_id"])
      rescue NoMethodError
        render json: { error: "Authentification error: Invalid token" }, status: :unauthorized
      else
        render json: current_user.as_json, status: :ok
      end
    end
    # logout
    def destroy # need to test
      render body: nil, status: :ok
    end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end
  end
end
