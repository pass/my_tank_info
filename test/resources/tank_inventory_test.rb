# frozen_string_literal: true

require "test_helper"

class TankInventoryResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/tanks/#{TANK_ID}/inventory",
        response: stub_response(fixture: "tank_inventory/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    tanks = client.tank_inventory.list(tank_id: TANK_ID)

    assert_equal MyTankInfo::Collection, tanks.class
    assert_equal MyTankInfo::TankInventoryRecord, tanks.data.first.class
  end
end
