# frozen_string_literal: true

require "test_helper"

class SitegroupInventoryDashboardsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/sitegroups/#{SITEGROUP_ID}/inventory/dashboard",
        response: stub_response(fixture: "sitegroup_inventory_dashboards/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    dashboards = client.sitegroup_inventory_dashboards.list(sitegroup_id: SITEGROUP_ID)

    assert_equal MyTankInfo::Collection, dashboards.class
    assert_equal MyTankInfo::SitegroupInventoryDashboard, dashboards.data.first.class
  end
end
