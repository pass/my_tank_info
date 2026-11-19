# frozen_string_literal: true

require "test_helper"

class ObjectTest < Minitest::Test
  def test_strips_null_bytes_from_strings_at_any_depth
    object = MyTankInfo::Object.new({
      "SensorName" => "DISP 1\0\0",
      "Site" => { "Name" => "Store\0" },
      "Labels" => [ "A\0", { "Text" => "B\0" } ],
      "Number" => 1
    })

    assert_equal "DISP 1", object.sensor_name
    assert_equal "Store", object.site.name
    assert_equal [ "A", { "Text" => "B" } ], object.labels
    assert_equal 1, object.number
  end
end
