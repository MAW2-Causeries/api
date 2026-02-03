module Api
  class UsersController < ApplicationController
    protect_from_forgery with: :null_session

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
      render json: { error: "The username and/or email has already be taken" }, status: :forbidden
    end
  end
  # update specific user id
  def update
    user = User.find_by(uuid: params[:id])

    begin
      user.update_columns({ username: params[:username], profile_picture_path: params[:profile_picture_path], password_digest: user.generate_password(params[:password]) })
      head :ok
    rescue NoMethodError
      render json: InvalideUserData.new, status: :unprocessable_entity
    end
  end

  # kill the user
  def destroy
    begin
      User.find_by!(uuid: params[:id]).destroy
      head :ok
    rescue ActiveRecord::RecordNotFound
      render json: UserNotFound.new, status: :not_found
    end
  end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end
  end
end
