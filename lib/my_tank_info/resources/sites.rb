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
  end
end
