# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "my_tank_info"

require "minitest/autorun"

require "faraday"
require "json"

class Minitest::Test
  SITE_ID = 1489
  TANK_ID = 1770
  SITEGROUP_ID = 73
  CONTACT_ID = 306
  NOTIFICATION_RULE_ID = 82425
  NOTIFICATION_CODE_ID = 12
  DELIVERY_ID = 123
  TANK_RULE_ID = 123
  ALARM_ID = 123
  ALARM_NOTE_ID = 123

  def stub_response(fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    [status, headers, File.read("test/fixtures/#{fixture}.json")]
  end

  def stub_request(path, response:, method: :get, body: {})
    Faraday::Adapter::Test::Stubs.new do |stub|
      arguments = [method, path]
      arguments << body.to_json if [:post, :put, :patch].include?(method)
      stub.send(*arguments) { |env| response }
    end
  end
end
