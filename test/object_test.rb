# frozen_string_literal: true

require "test_helper"

class ObjectTest < Minitest::Test
  def test_handles_nil_attributes
    object = MyTankInfo::Object.new(nil)

    assert object.title.nil?
  end

  def test_handles_empty_attributes
    object = MyTankInfo::Object.new({})

    assert object.title.nil?
  end

  def test_object_doesnt_override_object_methods
    attributes = {
      "ObjectId" => "12345",
      "ObjectType" => "tank",
      "SensorName" => "REGULAR",
      "PrivateMethods" => "not_good"
    }

    object = MyTankInfo::Object.new(attributes)

    refute_equal "12345", object.object_id
    assert_kind_of Integer, object.object_id

    assert_equal "tank", object.object_type
    assert_equal "tank", object.object_type
    assert_equal "REGULAR", object.sensor_name

    refute_equal "not_good", object.private_methods
    assert_kind_of Array, object.private_methods
  end
end
