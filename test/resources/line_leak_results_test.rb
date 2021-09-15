# frozen_string_literal: true

require "test_helper"

class LineLeakResultsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/lineleaks",
        response: stub_response(fixture: "line_leak_results/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.line_leak_results.list(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::LineLeakResult, results.data.first.class
  end
end
