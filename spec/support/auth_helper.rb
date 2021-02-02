module AuthHelper
  def http_login
    token = Token.create.key
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
  end
end
