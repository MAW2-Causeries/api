module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_api_user!

      rescue_from StandardError, with: :render_internal_server_error
      rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
      rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from ActiveRecord::RecordNotUnique, with: :render_record_not_unique
      rescue_from ActiveRecord::InvalidForeignKey, with: :render_invalid_foreign_key

      def route_not_found
        render_error("Route not found", status: :not_found, code: "route_not_found")
      end

      private

      def authenticate_api_user!
        return if current_api_user || jwt_bypass_host?

        render_error("You need to sign in or sign up before continuing.", status: :unauthorized, code: "authentication_error")
      end

      def current_api_user
        @current_api_user ||= warden.authenticate(scope: :user)
      end

      def jwt_bypass_host?
        configured_jwt_bypass_hosts.any? do |configured_host|
          configured_host.casecmp?(request.host) || configured_host.casecmp?(request.host_with_port)
        end
      end

      def configured_jwt_bypass_hosts
        ENV.fetch("API_JWT_BYPASS_HOSTS", "")
          .split(",")
          .map(&:strip)
          .reject(&:empty?)
      end

      def render_error(message, status:, code:)
        render json: { error: { code: code, message: message } }, status: status
      end

      def render_parameter_missing(error)
        render_error(error.message, status: :bad_request, code: "parameter_missing")
      end

      def render_record_not_found(error)
        render_error(error.message, status: :not_found, code: "record_not_found")
      end

      def render_record_invalid(error)
        render_error(error.record.errors.full_messages.to_sentence, status: :unprocessable_entity, code: "record_invalid")
      end

      def render_record_not_unique(error)
        render_error(error.message, status: :unprocessable_entity, code: "record_not_unique")
      end

      def render_invalid_foreign_key(error)
        render_error(error.message, status: :unprocessable_entity, code: "invalid_foreign_key")
      end

      def render_internal_server_error(error)
        logger.error("#{error.class}: #{error.message}")
        logger.error(error.backtrace.join("\n")) if error.backtrace

        render_error("Internal server error", status: :internal_server_error, code: "internal_server_error")
      end
    end
  end
end
