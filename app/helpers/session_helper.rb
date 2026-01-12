module SessionHelper
  JWT_SECRET = ENV["JWT_SECRET"]
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
end
