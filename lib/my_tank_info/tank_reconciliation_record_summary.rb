# frozen_string_literal: true

module MyTankInfo
  class TankReconciliationRecordSummary
    attr_reader :records

    MONTHLY_FUDGE_NUMBER = 130
    TEN_DAY_MULTIPLIER = 0.0075
    SEVEN_DAY_MULTIPLIER = 0.005

    def initialize(records, capacity:, reconciliation_period:)
      @records = records
      @capacity = capacity
      @reconciliation_period = reconciliation_period
    end

    def total_deliveries_volume
      @records.sum(&:deliveries_volume).round(0)
    end

    def total_sales_volume
      @records.sum(&:sales_volume).round(0)
    end

    def total_over_short
      @records.sum(&:difference_volume).round(0)
    end

    def absolute_difference_volume
      total_over_short.abs
    end

    # Monthly Reconciliation Specific Logic
    def total_gallons_pumped
      total_sales_volume
    end

    def leak_check_number
      # DROP THE LAST 2 DIGITS FROM THE PUMPED NUMBER AND ENTER ON THE LEAK CHECK
      (total_gallons_pumped.to_f / 100).round(0).to_i
    end

    def leak_check_result
      leak_check_number + MONTHLY_FUDGE_NUMBER
    end

    def leak_check_result_unacceptable?
      absolute_difference_volume > leak_check_result
    end

    # 10 Day Reconciliation Specific Logic
    def allowance_multiplier
      [@capacity, total_deliveries_volume, total_sales_volume].max
    end

    def allowable_tolerance
      (allowance_multiplier.to_f * TEN_DAY_MULTIPLIER).round(0).to_i
    end

    def variance_is_gt_allowable_tolerance?
      absolute_difference_volume > allowable_tolerance
    end

    # Weekly / 7 Day Reconciliation Specific Logic
    def weekly_number_to_check
      [total_gallons_pumped, @capacity].max
    end

    def weekly_check_number
      (weekly_number_to_check.to_f * SEVEN_DAY_MULTIPLIER).round(0).to_i
    end

    def total_gallons_larger_than_leak_check?
      absolute_difference_volume > weekly_check_number
    end

    def allowable_variance
      case @reconciliation_period
      when :monthly
        leak_check_result
      when :ten_day
        allowable_tolerance
      when :weekly
        weekly_check_number
      else
        raise ReconciliationPeriodMissingError.new
      end
    end

    def failed?
      case @reconciliation_period
      when :monthly
        leak_check_result_unacceptable?
      when :ten_day
        variance_is_gt_allowable_tolerance?
      when :weekly
        total_gallons_larger_than_leak_check?
      else
        raise ReconciliationPeriodMissingError.new
      end
    end

    def passed?
      !failed?
    end
  end

  class ReconciliationPeriodMissingError < Error
    def initialize
      super("reconciliation_period must be one of the following values: :monthly, :ten_day, :weekly")
    end
  end
end
