# frozen_string_literal: true

require "test_helper"

class TokensResourceTest < Minitest::Test
  def test_generate
    body = {
      username: "kyle@example.com",
      password: "p@33w0rd"
    }

    stub =
      stub_request(
        "/api/token",
        method: :post,
        body: body,
        response: [200, {"Content-Type" => "application/json"}, "\"bearer_token_goes_here\""]
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    token = client.generate_api_token(**body)

    assert_equal "bearer_token_goes_here", token
  end
end
