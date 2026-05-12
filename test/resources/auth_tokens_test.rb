# frozen_string_literal: true

require "test_helper"

class AuthTokensResourceTest < Minitest::Test
  def test_generate
    captured_headers = nil
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("/api/token", {username: "kyle@example.com", password: "p@33w0rd"}.to_json) do |env|
        captured_headers = env.request_headers
        [200, {"Content-Type" => "application/json"}, File.read("test/fixtures/auth_tokens/generate.json")]
      end
    end

    client = MyTankInfo::JwtClient.new(base_url: "http://example.test", adapter: :test, stubs: stubs)
    token = client.auth_tokens.generate(username: "kyle@example.com", password: "p@33w0rd")

    assert_nil captured_headers["Authorization"]
    assert_equal MyTankInfo::AuthToken, token.class
    assert_equal "access-token-initial", token.access_token
    assert_equal "refresh-token-initial", token.refresh_token
    assert_equal 3600, token.expires_in
    assert_equal 2_592_000, token.refresh_expires_in
    assert_equal "Bearer", token.token_type
    assert_equal "external", token.scope
  end

  def test_refresh
    captured_headers = nil
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("/api/token/refresh", {refreshToken: "refresh-token-initial"}.to_json) do |env|
        captured_headers = env.request_headers
        [200, {"Content-Type" => "application/json"}, File.read("test/fixtures/auth_tokens/refresh.json")]
      end
    end

    client = MyTankInfo::JwtClient.new(base_url: "http://example.test", adapter: :test, stubs: stubs)
    token = client.auth_tokens.refresh(refresh_token: "refresh-token-initial")

    assert_nil captured_headers["Authorization"]
    assert_equal "access-token-refreshed", token.access_token
    assert_equal "refresh-token-rotated", token.refresh_token
  end

  def test_auth_token_computes_expires_at_timestamps
    now = Time.utc(2026, 5, 12, 12, 0, 0)
    attrs = {
      "accessToken" => "a",
      "refreshToken" => "r",
      "expiresIn" => 3600,
      "refreshExpiresIn" => 2_592_000
    }

    token = MyTankInfo::AuthToken.new(attrs, now: now)

    assert_equal now + 3600, token.access_token_expires_at
    assert_equal now + 2_592_000, token.refresh_token_expires_at
  end
end
