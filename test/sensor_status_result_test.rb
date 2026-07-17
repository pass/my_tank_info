# frozen_string_literal: true

require "test_helper"

class SensorStatusResultTest < Minitest::Test
  def test_passing_for_normal_status_text
    assert MyTankInfo::SensorStatusResult.new({ status: "Sensor Normal" }).passing?
    assert MyTankInfo::SensorStatusResult.new({ status: "Input Normal" }).passing?
  end

  def test_passing_trusts_status_text_over_status_is_good
    # MyTI returns status_is_good: false even on records whose status text
    # reads "Sensor Normal" — the text is authoritative.
    result = MyTankInfo::SensorStatusResult.new({ status: "Sensor Normal", status_is_good: false })

    assert result.passing?
  end

  def test_not_passing_for_non_normal_status_text
    refute MyTankInfo::SensorStatusResult.new({ status: "Sensor Fuel Alarm", status_is_good: false }).passing?
    refute MyTankInfo::SensorStatusResult.new({ status: "Sensor Setup Data Warning" }).passing?
  end

  def test_not_passing_for_negated_normal_status_text
    # Never observed from MyTI, but a substring match on "normal" would
    # score these as passing — guard the false-pass direction.
    refute MyTankInfo::SensorStatusResult.new({ status: "Sensor Abnormal" }).passing?
    refute MyTankInfo::SensorStatusResult.new({ status: "Not Normal" }).passing?
    refute MyTankInfo::SensorStatusResult.new({ status: "Sensor Non-Normal" }).passing?
    refute MyTankInfo::SensorStatusResult.new({ status: "abnormal" }).passing?
  end

  def test_not_passing_when_status_blank
    refute MyTankInfo::SensorStatusResult.new({ status: nil }).passing?
    refute MyTankInfo::SensorStatusResult.new({}).passing?
  end
end
