class UsersController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def new
    user = User.new
    render json: user
  end

  def create # #login
    user = User.new(user_params)
    if user.save
      token = generate_token(user) # Assuming you have a method to generate a token
      render json: { user: user, token: token }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def find_by_username # #register
    user = User.find_by(username: params[:username])
    if user
      token = generate_token(user) # Assuming you have a method to generate a token
      render json: { user: user, token: token }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def edit
    user = User.find(params[:id])
    render json: user
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end
end
