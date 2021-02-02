require 'pagy/extras/headers'

module Api
  class BaseController < ActionController::Base
    include ::ActionController::Cookies
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include Response
    include ExceptionHandler
    include Serializer
    include Pagy::Backend

    Pagy::VARS[:headers] = { page: 'Current-Page', items: 'Per-Page', pages: false, count: 'Total' }

    before_action :require_authentication
    skip_before_action :verify_authenticity_token

    def current_token
      @current_token ||= authenticate_token
    end

    def require_authentication
      authenticate_token || render_unauthorized('the access token provided is invalid or expired')
    end

    private

    def render_unauthorized(message)
      json_error_response(Response::ACCESS_TOKEN_EXCEPTION, message, :unauthorized)
    end

    def check_token_authorization(permission)
      json_error_response('Unauthorized Token', 'your token is not qualified to perform this action.', :unauthorized) unless current_token.permissions.include?(permission)
    end

    def authenticate_token
      authenticate_with_http_token do |token, _|
        if api_token = Token.active.find_by(key: token)
          # Compare the tokens in a time-constant manner, to mitigate timing attacks.
          ActiveSupport::SecurityUtils.secure_compare(
            ::Digest::SHA256.hexdigest(token),
            ::Digest::SHA256.hexdigest(api_token.key)
          )
          api_token
        end
      end
    end

    def render(*args, &block)
      pagy_headers_merge(@pagy) if @pagy
      super
    end
  end
end
