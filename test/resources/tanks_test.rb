# frozen_string_literal: true

require "test_helper"

class TanksResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/tanks",
        response: stub_response(fixture: "tanks/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    tanks = client.tanks.list

    assert_equal MyTankInfo::Collection, tanks.class
    assert_equal 27, tanks.size
    assert_equal MyTankInfo::Tank, tanks.data.first.class
  end

  def test_site_list
    stub =
      stub_request(
        "/api/tanks",
        response: stub_response(fixture: "tanks/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    tanks = client.tanks.list(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, tanks.class
    assert_equal 6, tanks.size
    assert_equal MyTankInfo::Tank, tanks.data.first.class
  end

  def test_retrieve
    stub =
      stub_request(
        "api/tanks/#{TANK_ID}",
        response: stub_response(fixture: "tanks/retrieve")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    contact = client.tanks.retrieve(tank_id: TANK_ID)

    assert_equal MyTankInfo::Tank, contact.class
  end
end
