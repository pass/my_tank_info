# frozen_string_literal: true

require "test_helper"

class TankSalesRecordsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "api/recon/sites/#{SITE_ID}/sales",
        response: stub_response(fixture: "tank_sales_records/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    records = client.tank_sales_records.list(site_id: SITE_ID)
    sample_record = records.data.first

    assert_equal MyTankInfo::Collection, records.class
    assert_equal 42, records.size
    
    assert_equal MyTankInfo::TankSalesRecord, sample_record.class
    assert_equal Time.utc(2025, 3, 20, 5, 0, 38), sample_record.starts_at
    assert_equal Time.utc(2025, 3, 21, 5, 0, 10), sample_record.ends_at

    refute sample_record.is_blend?
    refute sample_record.sent?
  end
end
