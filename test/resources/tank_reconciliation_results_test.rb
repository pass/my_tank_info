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
    records = client.tank_reconciliation_records.list(
      site_id: SITE_ID,
      reconciliation_period: :monthly
    )

    assert_equal MyTankInfo::TankReconciliationRecordCollection, records.class
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

    records = client.tank_reconciliation_records.retrieve(
      site_id: SITE_ID,
      reconciliation_period: :monthly,
      started_at: started_at
    )

    assert_equal MyTankInfo::TankReconciliationRecordCollection, records.class
    assert_equal MyTankInfo::TankReconciliationRecord, records.data.first.class
    assert_equal 5, records.size
  end

  def test_update
    started_at = "2021-09-14T02:00:00.0000000-05:00"

    body = [
      {
        id: 1371318,
        product_name: "ALC FREE RNL",
        start_date_time: "2021-09-19T02:00:00.0000000-05:00",
        end_date_time: "2021-09-20T02:00:00.0000000-05:00",
        start_volume: 3077,
        end_volume: 3037,
        deliveries_volume: 0,
        sales_volume: 42,
        difference_volume: 2,
        water_height: 0,
        volume_uom: "gal",
        height_uom: "in",
        site_id: 1489,
        tank_numbers: [
          5
        ],
        total_tanks_capacity: 3907,
        prev_id: 1370540,
        is_missing: false,
        auto_fill_needed: false,
        auto_filled_at: "2021-09-20T12:57:04.6766666+00:00",
        start_date_time_locked: true,
        end_date_time_locked: true
      }
    ]

    stub =
      stub_request(
        "/api/recon/sites/#{SITE_ID}/#{started_at}",
        method: :put,
        body: body,
        response: stub_response(fixture: "tank_reconciliation_results/update")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    records =
      client
        .tank_reconciliation_records
        .update(
          site_id: SITE_ID,
          date: started_at,
          reconciliation_period: :monthly,
          attributes: body
        )
    assert_equal MyTankInfo::TankReconciliationRecordCollection, records.class
    assert_equal MyTankInfo::TankReconciliationRecord, records.data.first.class
    assert_equal 5, records.size
  end
end
