# frozen_string_literal: true

require "faraday"

module MyTankInfo
  class JwtClient
    DEFAULT_TIMEOUT = 120

    attr_reader :base_url, :username,
      :access_token, :refresh_token,
      :access_token_expires_at, :refresh_token_expires_at,
      :token_type, :scope

    def initialize(base_url:, username: nil, password: nil,
      access_token: nil, refresh_token: nil,
      access_token_expires_at: nil, refresh_token_expires_at: nil,
      token_type: nil, scope: nil,
      adapter: Faraday.default_adapter, stubs: nil,
      timeout: DEFAULT_TIMEOUT, open_timeout: nil)
      @base_url = base_url
      @username = username
      @password = password
      @access_token = access_token
      @refresh_token = refresh_token
      @access_token_expires_at = access_token_expires_at
      @refresh_token_expires_at = refresh_token_expires_at
      @token_type = token_type
      @scope = scope
      @adapter = adapter
      @stubs = stubs
      @timeout = timeout
      @open_timeout = open_timeout
    end

    def auth_tokens
      AuthTokensResource.new(self)
    end

    def auth_headers
      access_token ? {Authorization: "Bearer #{access_token}"} : {}
    end

    def authenticate!
      raise Error, "username and password are required to authenticate" unless @username && @password

      apply_token!(auth_tokens.generate(username: @username, password: @password))
    end

    def refresh!
      raise UnauthorizedError, "no refresh_token available" unless @refresh_token

      apply_token!(auth_tokens.refresh(refresh_token: @refresh_token))
    end

    def with_auth_retry
      yield
    rescue UnauthorizedError
      raise if @retrying

      @retrying = true
      begin
        refresh_or_reauthenticate!
        yield
      ensure
        @retrying = false
      end
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = @base_url
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.options.timeout = @timeout if @timeout
        conn.options.open_timeout = @open_timeout if @open_timeout
        conn.adapter @adapter, @stubs
      end
    end

    private

    def refresh_or_reauthenticate!
      refresh!
    rescue UnauthorizedError
      raise unless @username && @password

      authenticate!
    end

    def apply_token!(token)
      @access_token = token.access_token
      @refresh_token = token.refresh_token
      @access_token_expires_at = token.access_token_expires_at
      @refresh_token_expires_at = token.refresh_token_expires_at
      @token_type = token.token_type
      @scope = token.scope
      token
    end
  end
end
