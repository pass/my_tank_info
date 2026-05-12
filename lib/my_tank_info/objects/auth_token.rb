# frozen_string_literal: true

module MyTankInfo
  class AuthToken < Object
    attr_reader :access_token_expires_at, :refresh_token_expires_at

    def initialize(attributes, now: Time.now)
      super(attributes)
      @access_token_expires_at = now + expires_in if expires_in
      @refresh_token_expires_at = now + refresh_expires_in if refresh_expires_in
    end
  end
end
