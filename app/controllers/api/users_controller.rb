module Api
  class UsersController < BaseController
    skip_before_action :authenticate_api_user!, only: :create
    before_action :set_user, only: %i[show update destroy]

    def show
      render json: @user.as_json, status: :ok
    end

    def create
      user = User.create!(create_user_params)
      render json: user.as_json, status: :created
    end

    def update
      @user.update!(update_user_params)
      render json: @user.as_json, status: :ok
    end

    def destroy
      @user.destroy
      head :ok
    end

    private

    def set_user
      @user = User.find_by!(id: params[:id])
    end

    def create_user_params
      params.permit(:email, :password, :username).to_h
    end

    def update_user_params
      params.permit(:username, :password).to_h.compact
    end
  end
end
