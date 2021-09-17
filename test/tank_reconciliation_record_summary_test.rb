# frozen_string_literal: true

require "test_helper"

class TankReconciliationRecordSummaryTest < Minitest::Test
  def test_calculations
    setup

    assert_equal MyTankInfo::TankReconciliationRecordSummary, @tank_reconciliation_summary.class

    assert_equal 10, @tank_reconciliation_records.size

    assert_equal 1439, @tank_reconciliation_summary.total_deliveries_volume
    assert_equal 890, @tank_reconciliation_summary.total_sales_volume
    assert_equal(-33, @tank_reconciliation_summary.total_over_short)
    assert_equal 33, @tank_reconciliation_summary.absolute_difference_volume

    # Monthly Values
    assert_equal 9, @tank_reconciliation_summary.leak_check_number
    assert_equal 139, @tank_reconciliation_summary.leak_check_result
    refute @tank_reconciliation_summary.leak_check_result_unacceptable?

    # Ten Day Values
    assert_equal 3907, @tank_reconciliation_summary.allowance_multiplier
    assert_equal 29, @tank_reconciliation_summary.allowable_tolerance
    assert @tank_reconciliation_summary.variance_is_gt_allowable_tolerance?

    # Weekly Values
    assert_equal 890, @tank_reconciliation_summary.total_gallons_pumped
    assert_equal 3907, @tank_reconciliation_summary.weekly_number_to_check
    assert_equal 20, @tank_reconciliation_summary.weekly_check_number
    assert @tank_reconciliation_summary.total_gallons_larger_than_leak_check?
  end

  private

  def setup
    stub =
      stub_request(
        "/api/recon/sites/#{SITE_ID}",
        response: stub_response(fixture: "tank_reconciliation_results/calculations")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    @all_reconciliation_records = client.tank_reconciliation_records.list(site_id: SITE_ID)
    assert_equal 50, @all_reconciliation_records.size

    @tank = @all_reconciliation_records.tanks.first
    @tank_reconciliation_summary = @tank.reconciliation_summary
    @tank_reconciliation_records = @tank.reconciliation_records
  end
end
