module Api
  class UsersController < ApplicationController
    allow_unauthenticated_access
    def new
    end

    def register
      user = User.new(user_params)
      if user.save
        token = generate_token(user) # token generator
        start_new_session_for(user)
        render json: { user: user, token: token }, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
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
  end
end
