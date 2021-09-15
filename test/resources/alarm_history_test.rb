# frozen_string_literal: true

require "test_helper"

class AlarmHistoryResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/alarmhistory",
        response: stub_response(fixture: "alarm_history/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    alarm_history = client.alarm_history.list

    assert_equal MyTankInfo::Collection, alarm_history.class
    assert_equal 22, alarm_history.size
    assert_equal MyTankInfo::Alarm, alarm_history.data.first.class
  end

  def test_site_list
    stub =
      stub_request(
        "api/sites/#{SITE_ID}/alarmhistory",
        response: stub_response(fixture: "alarm_history/site_list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    alarm_history = client.alarm_history.list(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, alarm_history.class
    assert_equal 16, alarm_history.size
    assert_equal MyTankInfo::Alarm, alarm_history.data.first.class
  end
end
