# frozen_string_literal: true

module MyTankInfo
  class AuthTokensResource < Resource
    def generate(username:, password:)
      response = post_request(
        "api/token",
        body: {username: username, password: password},
        skip_auth: true
      )
      AuthToken.new(response.body)
    end

    def refresh(refresh_token:)
      response = post_request(
        "api/token/refresh",
        body: {refreshToken: refresh_token},
        skip_auth: true
      )
      AuthToken.new(response.body)
    end
  end
end
