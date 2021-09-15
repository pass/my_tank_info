# frozen_string_literal: true

require "test_helper"

class TankRunoutResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/tanks/#{TANK_ID}/runout",
        response: stub_response(fixture: "tank_runout/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    tanks = client.tank_runout.list(tank_id: TANK_ID)

    assert_equal MyTankInfo::Collection, tanks.class
    assert_equal MyTankInfo::TankRunoutRecord, tanks.data.first.class
  end
end
