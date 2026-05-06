# frozen_string_literal: true

module MyTankInfo
  class SitesResource < Resource
    def poll_inventory(site_id:)
      post_request("api/sites/#{site_id}/pollnow/", body: {})
    end

    def current_sensor_status(site_id:)
      response = get_request("api/environmental/sites/#{site_id}/sensorstatus/current")
      Collection.from_response(response, type: SensorStatusResult)
    end

    def passive_poll(site_id:, timeout_seconds: nil)
      path = "api/sites/#{site_id}/passivepoll"
      path += "?timeoutSeconds=#{timeout_seconds}" unless timeout_seconds.nil?

      body = post_request(path, body: {}).body || {}

      tanks = (body["tanks"] || []).map do |tank|
        {
          tank_id: tank["tank_id"],
          tank_number: tank["tank_number"],
          product_name: tank["product_name"],
          capacity: tank["capacity"],
          inventory: (tank["inventory"] || []).map { |row| TankInventoryRecord.new(row) }
        }
      end

      {
        site: body["site"] && Site.new(body["site"]),
        tanks: tanks,
        alarms: (body["alarms"] || []).map { |alarm| Alarm.new(alarm) }
      }
    end
  end
end
