# frozen_string_literal: true

require "test_helper"

class TankReconciliationRecordSummaryTest < Minitest::Test
  def test_calculations
    setup

    assert_equal MyTankInfo::TankReconciliationRecordSummary, @tank_reconciliation_summary.class
    assert_equal "E-10", @tank.product_name

    assert_equal 10, @tank_reconciliation_records.size

    assert_equal 6989, @tank_reconciliation_summary.total_deliveries_volume
    assert_equal 8437, @tank_reconciliation_summary.total_sales_volume
    assert_equal(-18, @tank_reconciliation_summary.total_over_short)
    assert_equal 18, @tank_reconciliation_summary.absolute_difference_volume

    # Monthly Values
    assert_equal 84, @tank_reconciliation_summary.leak_check_number
    assert_equal 214, @tank_reconciliation_summary.leak_check_result
    refute @tank_reconciliation_summary.leak_check_result_unacceptable?

    # Ten Day Values
    assert_equal 9889, @tank_reconciliation_summary.allowance_multiplier
    assert_equal 74, @tank_reconciliation_summary.allowable_tolerance
    refute @tank_reconciliation_summary.variance_is_gt_allowable_tolerance?

    # Weekly Values
    assert_equal 8437, @tank_reconciliation_summary.total_gallons_pumped
    assert_equal 9889, @tank_reconciliation_summary.weekly_number_to_check
    assert_equal 49, @tank_reconciliation_summary.weekly_check_number
    refute @tank_reconciliation_summary.total_gallons_larger_than_leak_check?
  end

  def test_monthly_reconciliation_period_specific_methods
    setup(reconciliation_period: :monthly)
    refute @tank_reconciliation_summary.failed?
    assert @tank_reconciliation_summary.passed?

    assert_equal 214, @tank_reconciliation_summary.allowable_variance
  end

  def test_ten_day_reconciliation_period_specific_methods
    setup(reconciliation_period: :ten_day)
    refute @tank_reconciliation_summary.failed?
    assert @tank_reconciliation_summary.passed?

    assert_equal 74, @tank_reconciliation_summary.allowable_variance
  end

  def test_weekly_reconciliation_period_specific_methods
    setup(reconciliation_period: :weekly)
    refute @tank_reconciliation_summary.failed?
    assert @tank_reconciliation_summary.passed?

    assert_equal 49, @tank_reconciliation_summary.allowable_variance
  end

  private

  def setup(reconciliation_period: :monthly)
    stub =
      stub_request(
        "/api/recon/sites/#{SITE_ID}",
        response: stub_response(fixture: "tank_reconciliation_results/calculations")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    @all_reconciliation_records =
      client.tank_reconciliation_records.list(
        site_id: SITE_ID,
        reconciliation_period: reconciliation_period
      )

    assert_equal 50, @all_reconciliation_records.size

    @tank = @all_reconciliation_records.tanks.first
    @tank_reconciliation_summary = @tank.reconciliation_summary
    @tank_reconciliation_records = @tank.reconciliation_records
  end
end
