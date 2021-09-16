# frozen_string_literal: true

require "test_helper"

class TankRulesResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/tanks/#{TANK_ID}/rules",
        response: stub_response(fixture: "tank_rules/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    rules = client.tank_rules.list(tank_id: TANK_ID)

    assert_equal MyTankInfo::Collection, rules.class
    assert_equal MyTankInfo::TankRule, rules.data.first.class
  end

  def test_update
    body = {
      start_date_and_time: "2021-08-10T11:48:00.0000000-04:00",
      start_gross: 500,
      stop_date_and_time: "2021-08-10T12:48:00.0000000-04:00",
      stop_gross: 600,
      delivery_net: 100,
      delivery_gross: 105,
      bol_number: "123"
    }

    stub =
      stub_request(
        "/api/tanks/#{TANK_ID}/rules/#{TANK_RULE_ID}",
        method: :put,
        body: body,
        response: stub_response(fixture: "tank_deliveries/update")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    rule = client.tank_rules.update(tank_id: TANK_ID, rule_id: DELIVERY_ID, **body)
    assert_equal MyTankInfo::TankRule, rule.class
  end
end
