module Api
  class SessionsController < ApplicationController
    allow_unauthenticated_access
    # allow_unauthenticated_access only: %i[ new create ]
    #  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

    def new
    end

    def check_token
      current_user
      if @current_user
        render json: { id: @current_user.id, username: @current_user.username, email: @current_user.email, avatarUrl: @current_user.profile_picture_path }, status: :ok
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def destroy
      terminate_session
      redirect_to new_session_path, status: :see_other
    end
  end
end
