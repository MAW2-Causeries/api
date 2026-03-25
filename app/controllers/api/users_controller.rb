module Api
  class UsersController < ApplicationController
    protect_from_forgery with: :null_session

    rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
    rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, with: :duplicate_record
    rescue_from NoMethodError, with: :invalid_record

  # get the specific user id and send back datas
  def show
    begin
      user = User.find_by!(uuid: params[:id])
      render json: user.as_json, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: UserNotFound.new, status: :not_found
    end
  end

  # register
  def create
    attrs = params[:user].present? ? user_params.to_h : params.permit(:email, :password, :username, :profile_picture_path).to_h

    user = User.new(attrs)
    unless user.username.match(/^[A-Za-z0-9]+$/)
      render json: InvalidUserData.new, status: :bad_request
      return
    end
    user.save!
    head :ok
  end
  # update specific user id
  def update
    user = User.find_by!(uuid: params[:id])
    user.update_columns({ username: params[:username], profile_picture_path: params[:profile_picture_path], password_digest: user.encode_password(params[:password]) })
    head :ok
  end

  # kill the user
  def destroy
    User.find_by!(uuid: params[:id]).destroy
    head :ok
  end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end

    def duplicate_record
      render json: DuplicateUser.new, status: :unprocessable_entity
    end

    def invalid_record
      render json: InvalidUserData.new, status: :unprocessable_entity
    end

    def user_not_found
      render json: UserNotFound.new, status: :not_found
    end
  end
end
