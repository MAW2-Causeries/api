module Api
  class UsersController < ApplicationController
    protect_from_forgery with: :null_session

  # get the specific user id and send back datas
  def show
    user = User.find_by(uuid: params[:id])
    render json: user.as_json, status: :ok
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
    username = params[:username]
    password_digest = BCrypt::Password.create(params[:password]) # redo make pw
    profile_picture_path = params[:profile_picture_path]
    user = User.find_by(uuid: params[:id])

    if user.update_columns({ username: username, profile_picture_path: profile_picture_path, password_digest: password_digest })
      head :ok
    else
      render json: { error: "The user couldn't be updated" }, status: :internal_server_error
    end
  end
  # kill
  def destroy
    user = User.find_by(uuid: params[:id])
    if user.destroy
      head :ok
    else
      render json: { error: "The user couldn't be delete" }, status: :internal_server_error
    end
  end

    def user_params
      params.require(:user).permit(:email, :password, :username, :profile_picture_path)
    end
  end
end
