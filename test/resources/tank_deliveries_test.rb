# frozen_string_literal: true

require "test_helper"

class TankDeliveriesResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/tanks/#{TANK_ID}/deliveries",
        response: stub_response(fixture: "tank_deliveries/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    tanks = client.tank_deliveries.list(tank_id: TANK_ID)

    assert_equal MyTankInfo::Collection, tanks.class
    assert_equal MyTankInfo::TankDeliveryRecord, tanks.data.first.class
  end
end
