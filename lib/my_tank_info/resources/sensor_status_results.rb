# frozen_string_literal: true

module MyTankInfo
  class SensorStatusResultsResource < Resource
    def list(site_id:, **params)
      response = get_request("api/environmental/sites/#{site_id}/sensorstatuses", params: params)
      Collection.from_response(response, type: SensorStatusResult)
    end
  end
end
