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
        # token = encode_tokenjwt({ user_id: user.id })
        # might need this later
        head :ok
        # render json: { user: { id: user.id, username: user.username, email: user.email }, token: token }, status: :ok
        # might need this later
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      email = params[:email]
      password = params[:password]
      user = User.find_by(email: email)
      if BCrypt::Password.new(user.password_digest) == password && user.email == email
        token = encode_tokenjwt({ user_id: user.id })
        puts token
        start_new_session_for(user)
        render json: { id: user.id, username: user.username, email: user.email, avatarUrl: user.profile_picture_path, token: token }, status: :ok
      elsif user
        render json: { error: "Invalid password or username" }, status: :unauthorized
      else
        render json: { error: "User not found" }, status: :not_found
      end
    end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end
  end
end
