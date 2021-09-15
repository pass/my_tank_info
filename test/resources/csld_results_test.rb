# frozen_string_literal: true

require "test_helper"

class CsldResultsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/environmental/sites/#{TEST_SITE_ID}/csldstatuses",
        response: stub_response(fixture: "csld_results/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    csld_results = client.csld_results.list(site_id: TEST_SITE_ID)

    assert_equal MyTankInfo::Collection, csld_results.class
    assert_equal MyTankInfo::CsldResult, csld_results.data.first.class
  end
end
