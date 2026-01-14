# frozen_string_literal: true

require "test_helper"

class SitesResourceTest < Minitest::Test
  def test_poll_inventory
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [200, {"Content-Type" => "application/json"}, '{"status":"ok"}']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    response = client.sites.poll_inventory(site_id: SITE_ID)

    assert_equal 200, response.status
    assert_equal "ok", response.body["status"]
  end

  def test_poll_inventory_unauthorized
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [401, {"Content-Type" => "application/json"}, '"Invalid token"']
      )

    client = MyTankInfo::Client.new(api_key: "bad_key", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::UnauthorizedError do
      client.sites.poll_inventory(site_id: SITE_ID)
    end
  end

  def test_poll_inventory_forbidden
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [403, {"Content-Type" => "application/json"}, '"Access denied"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::RequestForbiddenError do
      client.sites.poll_inventory(site_id: SITE_ID)
    end
  end

  def test_poll_inventory_not_found
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [404, {"Content-Type" => "application/json"}, '"Site not found"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::NotFoundError do
      client.sites.poll_inventory(site_id: SITE_ID)
    end
  end

  def test_poll_inventory_server_error
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [500, {"Content-Type" => "application/json"}, '"Internal error"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::InternalServerError do
      client.sites.poll_inventory(site_id: SITE_ID)
    end
  end
end
