require "jwt"

class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  JWT_SECRET = ENV["JWT_SECRET"]
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def encode_tokenjwt(payload)
    JWT.encode(payload, JWT_SECRET)
  end

  def decode_tokenjwt
    header = params[:Authorization]
    begin
      JWT.decode(header, JWT_SECRET, true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    if decode_tokenjwt
      user_id = decode_tokenjwt[0]["user_id"]
      @current_user = User.find_by(uuid: user_id)
    end
  end

  def authorized
    unless !!current_user
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end
end
