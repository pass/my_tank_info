# frozen_string_literal: true

require "test_helper"

class TankLeakResultsResourceTest < Minitest::Test
  def test_list
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/tankleaks",
        response: stub_response(fixture: "tank_leak_results/list")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.tank_leak_results.list(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal MyTankInfo::TankLeakResult, results.data.first.class
  end

  def test_list_raises_on_unexpected_status
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/tankleaks",
        response: [418, {"Content-Type" => "text/html"}, "<html><body>I'm a teapot</body></html>"]
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    error =
      assert_raises MyTankInfo::UnexpectedResponseError do
        client.tank_leak_results.list(site_id: SITE_ID)
      end

    assert_includes error.message, "418"
    assert_includes error.message, "teapot"
  end

  def test_list_raises_service_unavailable_on_gateway_errors
    [502, 503, 504].each do |status|
      stub =
        stub_request(
          "/api/environmental/sites/#{SITE_ID}/tankleaks",
          response: [status, {"Content-Type" => "text/html"}, "<html><body>Service Unavailable</body></html>"]
        )

      client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

      error =
        assert_raises MyTankInfo::ServiceUnavailableError do
          client.tank_leak_results.list(site_id: SITE_ID)
        end

      assert_equal status, error.status
      assert_includes error.message, status.to_s
      assert_includes error.message, "Service Unavailable"
    end
  end

  def test_list_raises_on_non_json_body
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/tankleaks",
        response: [200, {"Content-Type" => "text/html"}, "Unexpected plain text body"]
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    error =
      assert_raises MyTankInfo::UnexpectedResponseError do
        client.tank_leak_results.list(site_id: SITE_ID)
      end

    assert_includes error.message, "Unexpected plain text body"
  end
end
