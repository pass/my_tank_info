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
        "/api/tanks/#{TANK_ID}/deliveries/#{DELIVERY_ID}",
        method: :put,
        body: body,
        response: stub_response(fixture: "tank_deliveries/update")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::MissingRequiredAttributeError do
      bad_body = body.except(:bol_number)
      client.tank_deliveries.update(tank_id: TANK_ID, delivery_id: DELIVERY_ID, **bad_body)
    end

    deliery_record = client.tank_deliveries.update(tank_id: TANK_ID, delivery_id: DELIVERY_ID, **body)
    assert_equal MyTankInfo::TankDeliveryRecord, deliery_record.class
  end
end
