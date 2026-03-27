Devise.setup do |config|
  config.mailer_sender = ENV.fetch("DEVISE_MAILER_SENDER", "please-change-me@example.com")
  require "devise/orm/active_record"

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth, :params_auth ]
  config.parent_controller = "Api::BaseController"
  config.navigational_formats = []
  config.sign_out_via = :delete

  config.jwt do |jwt|
    jwt.secret = ENV["DEVISE_JWT_SECRET_KEY"].presence || ENV["JWT_SECRET"].presence || Rails.application.secret_key_base
    jwt.dispatch_requests = [
      [ "POST", %r{^/api/sessions$} ]
    ]
    jwt.revocation_requests = [
      [ "DELETE", %r{^/api/sessions$} ]
    ]
    jwt.expiration_time = 1.day.to_i
    jwt.request_formats = {
      user: [ :json ]
    }
  end
end
