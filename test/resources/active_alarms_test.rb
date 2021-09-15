# frozen_string_literal: true

require "test_helper"

class ActiveAlarmsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/alarms",
        response: stub_response(fixture: "active_alarms/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    active_alarms = client.active_alarms.list

    assert_equal MyTankInfo::Collection, active_alarms.class
    assert_equal 2, active_alarms.data.size
    assert_equal MyTankInfo::Alarm, active_alarms.data.first.class
  end

  def test_site_list
    stub =
      stub_request(
        "/api/alarms",
        response: stub_response(fixture: "active_alarms/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    active_alarms = client.active_alarms.list(site_id: TEST_SITE_ID)

    assert_equal MyTankInfo::Collection, active_alarms.class
    assert_equal 1, active_alarms.data.size
    assert_equal MyTankInfo::Alarm, active_alarms.data.first.class
  end
end
