# frozen_string_literal: true

module MyTankInfo
  class TokensResource < Resource
    def generate(**attributes)
      response = post_request("api/token", body: attributes)
      response.body.delete('"')
    end
  end
end
