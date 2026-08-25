# frozen_string_literal: true

require "test_helper"

class TankSalesRecordTest < Minitest::Test
  def test_parses_iso_8601_dates_from_current_host
    record = MyTankInfo::TankSalesRecord.new({
      begin_date_time: "2026-08-24T02:00:00",
      end_date_time: "2026-08-25T02:14:30"
    })

    assert_equal Time.parse("2026-08-24T02:00:00"), record.starts_at
    assert_equal Time.parse("2026-08-25T02:14:30"), record.ends_at
  end

  def test_parses_iso_8601_dates_with_offset
    record = MyTankInfo::TankSalesRecord.new({
      begin_date_time: "2026-08-25T02:14:30.0000000-04:00"
    })

    assert_equal Time.parse("2026-08-25T06:14:30Z"), record.starts_at
  end

  def test_parses_legacy_ms_json_dates
    record = MyTankInfo::TankSalesRecord.new({
      begin_date_time: "/Date(1620792000000)/",
      end_date_time: "/Date(1620878400000-0400)/"
    })

    assert_equal Time.utc(2021, 5, 12, 4, 0, 0), record.starts_at
    assert_equal Time.utc(2021, 5, 13, 4, 0, 0), record.ends_at
  end

  def test_iso_dates_do_not_collapse_to_epoch
    # The old parser extracted the first digit run from ISO strings — the
    # year — and produced 1970-01-01 00:00:02. Guard the regression.
    record = MyTankInfo::TankSalesRecord.new({ begin_date_time: "2026-08-25T02:14:30" })

    assert_operator record.starts_at, :>, Time.utc(2000)
  end

  def test_returns_nil_for_blank_dates
    assert_nil MyTankInfo::TankSalesRecord.new({ begin_date_time: nil }).starts_at
    assert_nil MyTankInfo::TankSalesRecord.new({ begin_date_time: "" }).starts_at
  end
end
