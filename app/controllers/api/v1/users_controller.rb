module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate_api_user!, only: :create
      before_action :set_user, only: %i[show update destroy channels]
      before_action :only_current_user!, only: %i[update destroy]

      def index
        users = User.all
        render json: users.as_json, status: :ok
      end

      def show
        render json: @user.as_json, status: :ok
      end

      def create
        User.create!(create_user_params)
        head :ok
      end

      def update
        @user.update!(update_user_params)
        render json: @user.as_json, status: :ok
      end

      def destroy
        @user.destroy
        head :ok
      end

      def channels
        render json: @user.channels.as_json, status: :ok
      end

      private

      def set_user
        @user = User.find_by!(id: params[:id])
      end

      def only_current_user!
        head :forbidden unless @user == current_user
      end

      def create_user_params
        params.permit(:email, :password, :username).to_h
      end

      def update_user_params
        params.permit(:username, :password).to_h.compact
      end
    end
  end
end
