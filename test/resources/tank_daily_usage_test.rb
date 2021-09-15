# frozen_string_literal: true

require "test_helper"

class TankDailyUsageResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/tanks/#{TANK_ID}/dailyusage",
        response: stub_response(fixture: "tank_daily_usage/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    tanks = client.tank_daily_usage.list(tank_id: TANK_ID)

    assert_equal MyTankInfo::Collection, tanks.class
    assert_equal MyTankInfo::TankDailyUsageRecord, tanks.data.first.class
  end
end
