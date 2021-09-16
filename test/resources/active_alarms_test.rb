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
    assert_equal 2, active_alarms.size
    assert_equal MyTankInfo::Alarm, active_alarms.data.first.class
  end

  def test_site_list
    stub =
      stub_request(
        "/api/alarms",
        response: stub_response(fixture: "active_alarms/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    active_alarms = client.active_alarms.list(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, active_alarms.class
    assert_equal 1, active_alarms.size
    assert_equal MyTankInfo::Alarm, active_alarms.data.first.class
  end

  def test_list_notes
    stub =
      stub_request(
        "/api/alarms/#{ALARM_ID}/notes",
        response: stub_response(fixture: "active_alarms/list_notes")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    active_alarms = client.active_alarms.list_notes(alarm_id: ALARM_ID)

    assert_equal MyTankInfo::Collection, active_alarms.class
    assert_equal 2, active_alarms.size
    assert_equal MyTankInfo::AlarmNote, active_alarms.data.first.class
  end

  def test_retrieve
    stub =
      stub_request(
        "api/alarms/#{ALARM_ID}",
        response: stub_response(fixture: "active_alarms/retrieve")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    contact = client.active_alarms.retrieve(alarm_id: ALARM_ID)

    assert_equal MyTankInfo::Alarm, contact.class
  end
end
