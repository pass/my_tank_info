# frozen_string_literal: true

require "test_helper"

class InventorySitegroupsResourceTest < Minitest::Test
  def test_list
    stub = stub_request(
      "/api/sitegroups",
      response: stub_response(fixture: "inventory_sitegroups/list")
    )
    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    sitegroups = client.inventory_sitegroups.list(environmental: false)

    assert_equal MyTankInfo::Collection, sitegroups.class
    assert_equal MyTankInfo::InventorySitegroup, sitegroups.data.first.class

    site = sitegroups.data.first.sites.first
    assert_equal "Veeder-Root TLS-350", site.atg_type
    assert_equal "Veeder-Root TLS350", site.atg_manufacturer
    assert_equal "TLS350", site.atg_model
  end
end
