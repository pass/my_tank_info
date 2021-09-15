# frozen_string_literal: true

require "test_helper"

class TankLeakResultsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/environmental/sites/#{TEST_SITE_ID}/tankleaks",
        response: stub_response(fixture: "tank_leak_results/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.tank_leak_results.list(site_id: TEST_SITE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::TankLeakResult, results.data.first.class
  end
end
