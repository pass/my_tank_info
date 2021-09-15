# frozen_string_literal: true

require "test_helper"

class SensorStatusResultsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/environmental/sites/#{TEST_SITE_ID}/sensorstatuses",
        response: stub_response(fixture: "sensor_status_results/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.sensor_status_results.list(site_id: TEST_SITE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::SensorStatusResult, results.data.first.class
  end
end
