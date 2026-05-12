# frozen_string_literal: true

require "test_helper"

class JwtClientTest < Minitest::Test
  GENERATE_BODY = File.read("test/fixtures/auth_tokens/generate.json")
  REFRESH_BODY = File.read("test/fixtures/auth_tokens/refresh.json")
  JSON_CT = {"Content-Type" => "application/json"}.freeze

  class ProtectedResource < MyTankInfo::Resource
    def fetch
      get_request("/protected")
    end
  end

  def test_auth_headers_empty_without_token
    client = MyTankInfo::JwtClient.new(base_url: "http://example.test")
    assert_equal({}, client.auth_headers)
  end

  def test_auth_headers_with_existing_access_token
    client = MyTankInfo::JwtClient.new(base_url: "http://example.test", access_token: "abc")
    assert_equal({Authorization: "Bearer abc"}, client.auth_headers)
  end

  def test_authenticate_populates_token_state
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("/api/token", {username: "u", password: "p"}.to_json) do
        [200, JSON_CT, GENERATE_BODY]
      end
    end

    client = MyTankInfo::JwtClient.new(
      base_url: "http://example.test",
      username: "u", password: "p",
      adapter: :test, stubs: stubs
    )
    client.authenticate!

    assert_equal "access-token-initial", client.access_token
    assert_equal "refresh-token-initial", client.refresh_token
    assert_equal "Bearer", client.token_type
    assert_equal "external", client.scope
    assert client.access_token_expires_at > Time.now
    assert client.refresh_token_expires_at > Time.now
  end

  def test_authenticate_requires_credentials
    client = MyTankInfo::JwtClient.new(base_url: "http://example.test")
    assert_raises MyTankInfo::Error do
      client.authenticate!
    end
  end

  def test_refresh_requires_refresh_token
    client = MyTankInfo::JwtClient.new(base_url: "http://example.test")
    assert_raises MyTankInfo::UnauthorizedError do
      client.refresh!
    end
  end

  def test_request_retries_after_refresh_on_401
    protected_calls = 0
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/protected") do |env|
        protected_calls += 1
        if protected_calls == 1
          assert_equal "Bearer initial-access", env.request_headers["Authorization"]
          [401, JSON_CT, '"expired"']
        else
          assert_equal "Bearer access-token-refreshed", env.request_headers["Authorization"]
          [200, JSON_CT, '{"ok":true}']
        end
      end
      stub.post("/api/token/refresh", {refreshToken: "initial-refresh"}.to_json) do
        [200, JSON_CT, REFRESH_BODY]
      end
    end

    client = MyTankInfo::JwtClient.new(
      base_url: "http://example.test",
      access_token: "initial-access",
      refresh_token: "initial-refresh",
      adapter: :test, stubs: stubs
    )

    response = ProtectedResource.new(client).fetch

    assert_equal 200, response.status
    assert_equal 2, protected_calls
    assert_equal "access-token-refreshed", client.access_token
    assert_equal "refresh-token-rotated", client.refresh_token
  end

  def test_request_reauthenticates_when_refresh_fails_with_credentials
    protected_calls = 0
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/protected") do
        protected_calls += 1
        (protected_calls == 1) ? [401, JSON_CT, '"expired"'] : [200, JSON_CT, '{"ok":true}']
      end
      stub.post("/api/token/refresh", {refreshToken: "stale-refresh"}.to_json) do
        [401, JSON_CT, '"refresh expired"']
      end
      stub.post("/api/token", {username: "u", password: "p"}.to_json) do
        [200, JSON_CT, GENERATE_BODY]
      end
    end

    client = MyTankInfo::JwtClient.new(
      base_url: "http://example.test",
      username: "u", password: "p",
      access_token: "stale-access",
      refresh_token: "stale-refresh",
      adapter: :test, stubs: stubs
    )

    response = ProtectedResource.new(client).fetch

    assert_equal 200, response.status
    assert_equal "access-token-initial", client.access_token
    assert_equal "refresh-token-initial", client.refresh_token
  end

  def test_request_raises_when_refresh_fails_without_credentials
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/protected") { [401, JSON_CT, '"expired"'] }
      stub.post("/api/token/refresh", {refreshToken: "stale-refresh"}.to_json) do
        [401, JSON_CT, '"refresh expired"']
      end
    end

    client = MyTankInfo::JwtClient.new(
      base_url: "http://example.test",
      access_token: "stale-access",
      refresh_token: "stale-refresh",
      adapter: :test, stubs: stubs
    )

    assert_raises MyTankInfo::UnauthorizedError do
      ProtectedResource.new(client).fetch
    end
  end

  def test_request_does_not_retry_a_second_time
    protected_calls = 0
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/protected") do
        protected_calls += 1
        [401, JSON_CT, '"still expired"']
      end
      stub.post("/api/token/refresh", {refreshToken: "initial-refresh"}.to_json) do
        [200, JSON_CT, REFRESH_BODY]
      end
    end

    client = MyTankInfo::JwtClient.new(
      base_url: "http://example.test",
      access_token: "initial-access",
      refresh_token: "initial-refresh",
      adapter: :test, stubs: stubs
    )

    assert_raises MyTankInfo::UnauthorizedError do
      ProtectedResource.new(client).fetch
    end
    assert_equal 2, protected_calls
  end

  def test_timeout_options_applied_to_connection
    client = MyTankInfo::JwtClient.new(base_url: "http://example.test", timeout: 30, open_timeout: 5)

    assert_equal 30, client.connection.options.timeout
    assert_equal 5, client.connection.options.open_timeout
  end
end
