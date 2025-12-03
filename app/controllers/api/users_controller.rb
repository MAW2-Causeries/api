module Api
  class UsersController < ApplicationController
    allow_unauthenticated_access
    skip_before_action :authorized, only: %i[register login], raise: false
    skip_before_action :verify_authenticity_token, only: %i[register login], if: -> { request.format.json? }
    protect_from_forgery with: :null_session,  if: -> { request.format.json? }
    def new
    end

    def register
        attrs =
        if params[:user].present?
          user_params.to_h
        else
          # permit top-level keys when client sends non-nested JSON
          params.permit(:email, :password, :username, :profile_picture_path).to_h
        end
      user = User.new(attrs)
      if user.save
        head :ok
      else
        render json: { errors: "The username and/or email has already be taken" }, status: :unprocessable_entity
      end
    end

    def login
      email = params[:email]
      password = params[:password]
      user = User.find_by(email: email)
      begin
        BCrypt::Password.new(user.password_digest)
      rescue NoMethodError
        render json: { error: "Invalid password or email" }, status: :unauthorized
      else
        if BCrypt::Password.new(user.password_digest) == password
          token = encode_tokenjwt({ user_id: user.uuid })
          puts token
          render json: { id: user.uuid, username: user.username, email: user.email, avatarUrl: user.profile_picture_path, token: token }, status: :ok
        else
          render json: { error: "Invalid password or email" }, status: :unauthorized
        end
      end
    end

    def check_token
      current_user
      if @current_user
        render json: { id: @current_user.uuid, username: @current_user.username, email: @current_user.email, avatarUrl: @current_user.profile_picture_path }, status: :ok
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end
  end
end
