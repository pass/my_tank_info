# frozen_string_literal: true

require "test_helper"

class CollectionTest < Minitest::Test
  FakeResponse = Struct.new(:status, :body)

  def test_from_response_wraps_a_single_hash
    response = FakeResponse.new(200, {"id" => 1})
    collection = MyTankInfo::Collection.from_response(response, type: MyTankInfo::TankLeakResult)

    assert_equal 1, collection.size
    assert_equal MyTankInfo::TankLeakResult, collection.data.first.class
  end

  def test_from_response_keeps_an_array
    response = FakeResponse.new(200, [{"id" => 1}, {"id" => 2}])
    collection = MyTankInfo::Collection.from_response(response, type: MyTankInfo::TankLeakResult)

    assert_equal 2, collection.size
  end

  def test_from_response_raises_on_unexpected_body
    response = FakeResponse.new(200, "Not the JSON we expected")

    error =
      assert_raises MyTankInfo::UnexpectedResponseError do
        MyTankInfo::Collection.from_response(response, type: MyTankInfo::TankLeakResult)
      end

    assert_includes error.message, "HTTP 200"
    assert_includes error.message, "Not the JSON we expected"
  end

  def test_truncate_error_body_returns_short_bodies_unchanged
    assert_equal "short body", MyTankInfo.truncate_error_body("short body")
  end

  def test_truncate_error_body_caps_long_bodies
    overflow = 50
    long = "x" * (MyTankInfo::MAX_ERROR_BODY_LENGTH + overflow)
    truncated = MyTankInfo.truncate_error_body(long)

    assert truncated.start_with?("x" * MyTankInfo::MAX_ERROR_BODY_LENGTH)
    assert_includes truncated, "truncated #{overflow} chars"
  end
end
