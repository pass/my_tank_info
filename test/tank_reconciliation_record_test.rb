# frozen_string_literal: true

require "test_helper"

class TankReconciliationRecordTest < Minitest::Test
  def test_date_is_the_start_day_when_closeout_is_after_midnight
    record = build(starts: "2026-09-09T00:23:00.0000000-04:00", ends: "2026-09-10T00:23:00.0000000-04:00")

    assert_equal Date.new(2026, 9, 9), record.date
  end

  def test_date_is_the_start_day_when_closeout_is_before_midnight
    record = build(starts: "2026-09-10T23:51:00.0000000-04:00", ends: "2026-09-11T23:51:00.0000000-04:00")

    assert_equal Date.new(2026, 9, 10), record.date
  end

  def test_date_of_a_merged_record_when_closeout_moves_is_the_day_it_starts
    record = build(starts: "2026-09-23T00:29:00.0000000-04:00", ends: "2026-09-24T23:37:00.0000000-04:00")

    assert_equal Date.new(2026, 9, 23), record.date
  end

  def test_date_of_a_multi_day_outage_is_the_day_it_starts
    record = build(starts: "2026-02-17T00:43:00.0000000-05:00", ends: "2026-03-26T12:39:00.0000000-04:00")

    assert_equal Date.new(2026, 2, 17), record.date
  end

  def test_date_of_a_record_without_an_end_is_the_day_it_starts
    record = build(starts: "2026-09-10T23:51:00.0000000-04:00", ends: nil)

    assert_equal Date.new(2026, 9, 10), record.date
  end

  private

  def build(starts:, ends:)
    MyTankInfo::TankReconciliationRecord.new(start_date_time: starts, end_date_time: ends)
  end
end
