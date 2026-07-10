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

  def test_poll_inventory_rate_limited
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [429, {"Content-Type" => "application/json", "Retry-After" => "30"}, '"Too many requests"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    error =
      assert_raises MyTankInfo::RateLimitError do
        client.sites.poll_inventory(site_id: SITE_ID)
      end

    assert_equal "Your request exceeded the API rate limit - Too many requests", error.message
    assert_equal 30, error.retry_after
  end

  def test_poll_inventory_rate_limited_without_retry_after_header
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [429, {"Content-Type" => "application/json"}, '"Too many requests"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    error =
      assert_raises MyTankInfo::RateLimitError do
        client.sites.poll_inventory(site_id: SITE_ID)
      end

    assert_nil error.retry_after
  end

  def test_poll_inventory_rate_limited_with_http_date_retry_after
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/pollnow/",
        method: :post,
        body: {},
        response: [429, {"Content-Type" => "application/json", "Retry-After" => (Time.now + 60).httpdate}, '"Too many requests"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    error =
      assert_raises MyTankInfo::RateLimitError do
        client.sites.poll_inventory(site_id: SITE_ID)
      end

    assert_includes 55..60, error.retry_after
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

  def test_current_sensor_status
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/sensorstatus/current",
        response: stub_response(fixture: "sites/current_sensor_status")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    results = client.sites.current_sensor_status(site_id: SITE_ID)

    assert_equal MyTankInfo::Collection, results.class
    assert_equal 3, results.size
    assert_equal MyTankInfo::SensorStatusResult, results.data.first.class
  end

  def test_current_sensor_status_unauthorized
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/sensorstatus/current",
        response: [401, {"Content-Type" => "application/json"}, '"Invalid token"']
      )

    client = MyTankInfo::Client.new(api_key: "bad_key", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::UnauthorizedError do
      client.sites.current_sensor_status(site_id: SITE_ID)
    end
  end

  def test_current_sensor_status_forbidden
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/sensorstatus/current",
        response: [403, {"Content-Type" => "application/json"}, '"Access denied"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::RequestForbiddenError do
      client.sites.current_sensor_status(site_id: SITE_ID)
    end
  end

  def test_current_sensor_status_not_found
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/sensorstatus/current",
        response: [404, {"Content-Type" => "application/json"}, '"Site not found"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::NotFoundError do
      client.sites.current_sensor_status(site_id: SITE_ID)
    end
  end

  def test_current_sensor_status_server_error
    stub =
      stub_request(
        "/api/environmental/sites/#{SITE_ID}/sensorstatus/current",
        response: [500, {"Content-Type" => "application/json"}, '"Internal error"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::InternalServerError do
      client.sites.current_sensor_status(site_id: SITE_ID)
    end
  end

  def test_passive_poll
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/passivepoll",
        method: :post,
        body: {},
        response: stub_response(fixture: "sites/passive_poll")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    result = client.sites.passive_poll(site_id: SITE_ID)

    assert_equal [:site, :tanks, :alarms], result.keys

    assert_equal MyTankInfo::Site, result[:site].class
    assert_equal "Butler Tarkington - Sta 31", result[:site].name

    assert_equal 2, result[:tanks].size
    first_tank = result[:tanks].first
    assert_equal 1770, first_tank[:tank_id]
    assert_equal 1, first_tank[:tank_number]
    assert_equal "REGULAR", first_tank[:product_name]
    assert_equal 6048, first_tank[:capacity]
    assert_equal 2, first_tank[:inventory].size
    assert(first_tank[:inventory].all? { |row| row.is_a?(MyTankInfo::TankInventoryRecord) })
    assert_equal 1024, first_tank[:inventory].first.gross

    assert_equal 1771, result[:tanks].last[:tank_id]
    assert_equal "PREMIUM", result[:tanks].last[:product_name]

    assert_equal 2, result[:alarms].size
    assert(result[:alarms].all? { |alarm| alarm.is_a?(MyTankInfo::Alarm) })
    assert_equal 1920154, result[:alarms].first.canonical_id
  end

  def test_passive_poll_with_timeout_seconds
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/passivepoll?timeoutSeconds=60",
        method: :post,
        body: {},
        response: stub_response(fixture: "sites/passive_poll")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    result = client.sites.passive_poll(site_id: SITE_ID, timeout_seconds: 60)

    assert_equal 2, result[:tanks].size
    assert_equal 2, result[:alarms].size
  end

  def test_passive_poll_unauthorized
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/passivepoll",
        method: :post,
        body: {},
        response: [401, {"Content-Type" => "application/json"}, '"Invalid token"']
      )

    client = MyTankInfo::Client.new(api_key: "bad_key", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::UnauthorizedError do
      client.sites.passive_poll(site_id: SITE_ID)
    end
  end

  def test_passive_poll_forbidden
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/passivepoll",
        method: :post,
        body: {},
        response: [403, {"Content-Type" => "application/json"}, '"Access denied"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::RequestForbiddenError do
      client.sites.passive_poll(site_id: SITE_ID)
    end
  end

  def test_passive_poll_not_found
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/passivepoll",
        method: :post,
        body: {},
        response: [404, {"Content-Type" => "application/json"}, '"Site not found"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::NotFoundError do
      client.sites.passive_poll(site_id: SITE_ID)
    end
  end

  def test_run_atg_command
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgcommand",
        method: :post,
        body: {command: "I20100"},
        response: stub_response(fixture: "sites/run_atg_command")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    result = client.sites.run_atg_command(site_id: SITE_ID, command: "I20100")

    assert_equal MyTankInfo::AtgCommandResult, result.class
    assert_equal "ok", result.status
    assert_equal "I20100", result.command
    assert_equal 123456, result.event_id
    assert_in_delta 4.27, result.poll_duration_seconds
    assert_match(/IN-TANK INVENTORY/, result.results)
  end

  def test_run_atg_command_with_timeout_seconds
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgcommand?timeoutSeconds=60",
        method: :post,
        body: {command: "I20100"},
        response: stub_response(fixture: "sites/run_atg_command")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    result = client.sites.run_atg_command(site_id: SITE_ID, command: "I20100", timeout_seconds: 60)

    assert_equal MyTankInfo::AtgCommandResult, result.class
    assert_equal "ok", result.status
  end

  def test_run_atg_command_unauthorized
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgcommand",
        method: :post,
        body: {command: "I20100"},
        response: [401, {"Content-Type" => "application/json"}, '"Invalid token"']
      )

    client = MyTankInfo::Client.new(api_key: "bad_key", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::UnauthorizedError do
      client.sites.run_atg_command(site_id: SITE_ID, command: "I20100")
    end
  end

  def test_run_atg_command_forbidden
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgcommand",
        method: :post,
        body: {command: "I20100"},
        response: [403, {"Content-Type" => "application/json"}, '"Access denied"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::RequestForbiddenError do
      client.sites.run_atg_command(site_id: SITE_ID, command: "I20100")
    end
  end

  def test_run_atg_command_not_found
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgcommand",
        method: :post,
        body: {command: "I20100"},
        response: [404, {"Content-Type" => "application/json"}, '"Site not found"']
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::NotFoundError do
      client.sites.run_atg_command(site_id: SITE_ID, command: "I20100")
    end
  end

  def test_run_atg_multi_commands
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgmulticommands",
        method: :post,
        body: {commands: "I20100;I20200;I11100"},
        response: stub_response(fixture: "sites/run_atg_multi_commands")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    result = client.sites.run_atg_multi_commands(site_id: SITE_ID, commands: ["I20100", "I20200", "I11100"])

    assert_equal MyTankInfo::AtgMultiCommandResult, result.class
    assert_equal "ok", result.status
    assert_equal 123457, result.event_id
    assert_in_delta 9.81, result.poll_duration_seconds
    assert_equal 3, result.results.size
    assert_equal ["I20100", "I20200", "I11100"], result.results.map(&:command)
    assert_equal [0, 1, 2], result.results.map(&:sequence)
    assert_match(/IN-TANK INVENTORY/, result.response_for("I20100"))
    assert_match(/DELIVERY REPORT/, result.response_for("i20200"))
    assert_nil result.response_for("I99999")
  end

  def test_run_atg_multi_commands_accepts_preformatted_string
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgmulticommands?timeoutSeconds=600",
        method: :post,
        body: {commands: "I20100;I20200"},
        response: stub_response(fixture: "sites/run_atg_multi_commands")
      )

    client = MyTankInfo::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    result = client.sites.run_atg_multi_commands(site_id: SITE_ID, commands: "I20100;I20200", timeout_seconds: 600)

    assert_equal "ok", result.status
  end

  def test_run_atg_multi_commands_unauthorized
    stub =
      stub_request(
        "/api/sites/#{SITE_ID}/runatgmulticommands",
        method: :post,
        body: {commands: "I20100"},
        response: [401, {"Content-Type" => "application/json"}, '"Invalid token"']
      )

    client = MyTankInfo::Client.new(api_key: "bad_key", adapter: :test, stubs: stub)

    assert_raises MyTankInfo::UnauthorizedError do
      client.sites.run_atg_multi_commands(site_id: SITE_ID, commands: ["I20100"])
    end
  end
end
