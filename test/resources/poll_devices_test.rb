# frozen_string_literal: true

require "test_helper"

class PollDevicesResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "api/admin/polldevices",
        response: stub_response(fixture: "poll_devices/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.poll_devices.list

    assert_equal MyTankInfo::Collection, results.class
    assert_equal 2, results.size
    assert_equal MyTankInfo::PollDevice, results.data.first.class

    up, down = results.data
    assert_equal SITE_ID, up.site_id
    assert_equal "ifd31.site.acumera.net", up.ip
    assert_equal 10001, up.port
    assert up.link_up?

    assert_equal "DOWN", down.link_status
    refute down.link_up?
    assert_nil down.rms_last_connected_at
  end

  def test_retrieve
    stub =
      stub_request(
        "api/admin/#{SITE_ID}/polldevice",
        response: stub_response(fixture: "poll_devices/retrieve")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    device = client.poll_devices.retrieve(site_id: SITE_ID)

    assert_equal MyTankInfo::PollDevice, device.class
    assert_equal SITE_ID, device.site_id
    assert_equal SITEGROUP_ID, device.site_group_id
    assert_equal "IFD00000031", device.system_id
    assert_equal "IFD00000031", device.serial_number
    assert_equal 120, device.polling_frequency_secs
    assert_equal "356938035643809", device.imei
    assert_equal "Active", device.lattigo_state
    assert device.link_up?
    assert_equal Time.parse("2026-09-09T14:05:12.0000000+00:00"), device.link_last_checked_at
    assert_equal Time.parse("2026-09-09T13:59:44.0000000+00:00"), device.rms_last_connected_at
  end

  def test_retrieve_forbidden
    stub =
      stub_request(
        "api/admin/#{SITE_ID}/polldevice",
        response: [403, {"Content-Type" => "application/json"}, '"Access denied"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::RequestForbiddenError do
      client.poll_devices.retrieve(site_id: SITE_ID)
    end
  end

  def test_retrieve_not_found
    stub =
      stub_request(
        "api/admin/#{SITE_ID}/polldevice",
        response: [404, {"Content-Type" => "application/json"}, '"Site not found"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::NotFoundError do
      client.poll_devices.retrieve(site_id: SITE_ID)
    end
  end
end
