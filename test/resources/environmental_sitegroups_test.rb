# frozen_string_literal: true

require "test_helper"

class EnvironmentalSitegroupsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/environmental/sitegroups",
        response: stub_response(fixture: "environmental_sitegroups/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    sitegroups = client.environmental_sitegroups.list

    assert_equal MyTankInfo::Collection, sitegroups.class
    assert_equal MyTankInfo::EnvironmentalSitegroup, sitegroups.data.first.class
  end
end
