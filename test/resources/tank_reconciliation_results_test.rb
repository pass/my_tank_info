# frozen_string_literal: true

require "test_helper"

class TankReconciliationResultsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/recon/sites/#{SITE_ID}",
        response: stub_response(fixture: "tank_reconciliation_results/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    records = client.tank_reconciliation_records.list(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, records.class
    assert_equal MyTankInfo::TankReconciliationRecord, records.data.first.class
    assert_equal 50, records.size
  end

  def test_retrieve
    started_at = "2021-09-14T02:00:00.0000000-05:00"
    stub =
      stub_request(
        "/api/recon/sites/#{SITE_ID}/#{started_at}",
        response: stub_response(fixture: "tank_reconciliation_results/retrieve")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    records = client.tank_reconciliation_records.retrieve(site_id: SITE_ID, started_at: started_at)

    assert_equal MyTankInfo::Collection, records.class
    assert_equal MyTankInfo::TankReconciliationRecord, records.data.first.class
    assert_equal 5, records.size
  end
end
