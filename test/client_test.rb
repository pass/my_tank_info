# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  def test_timeout_options_applied_to_connection
    client = MyTankInfo::Client.new(api_key: "fake", timeout: 30, open_timeout: 5)

    assert_equal 30, client.connection.options.timeout
    assert_equal 5, client.connection.options.open_timeout
  end

  def test_timeout_options_default_to_faraday_defaults
    client = MyTankInfo::Client.new(api_key: "fake")

    assert_nil client.connection.options.timeout
    assert_nil client.connection.options.open_timeout
  end
end
